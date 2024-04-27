import azure.functions as func
import logging
import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage


app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    prefix= "alfdevapi3"
    queue_name=f"{prefix}servicebusqueue"

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    message = ""
    if name:
        message = f"Hello, {name}. This HTTP triggered function executed successfully."
    else:
        message = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response. ServiceBusConnection {serviceBusConnection} "


    servicebus_connection_string = os.environ["ServiceBusConnection"]
    logging.info(servicebus_connection_string)

    try:
        # Create a ServiceBusClient instance
        client = ServiceBusClient.from_connection_string(conn_str=servicebus_connection_string, logging_enable=True)

        logging.info(f"Sending message to {queue_name}")     

        # Send the message to the queue
        with client.get_queue_sender(queue_name=queue_name) as sender:
            service_bus_message = ServiceBusMessage(body=message.encode())
            sender.send_messages(service_bus_message)
            logging.info(f"Message sent to queue: {queue_name}")


    except Exception as ex:
        logging.error(f"Error connecting to Azure Service Bus: {ex}")
        return func.HttpResponse(
            body=f"An error occurred while connecting to Azure Service Bus: {ex}",
            status_code=500
        )

    finally:
        # Close the client to avoid resource leaks
        logging.info("Close all connections here")
        client.close()

    return func.HttpResponse(
            message,
            status_code=200
    )