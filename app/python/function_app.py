import azure.functions as func
import logging
import os
import logging
from azure.servicebus import ServiceBusClient, ServiceBusMessage


app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)



@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    servicebus_connection_string = os.environ["ServiceBusConnection"]
    logging.info(servicebus_connection_string)

    try:
        # Create a ServiceBusClient instance
        client = ServiceBusClient.from_connection_string(conn_str=servicebus_connection_string)


    # except Exception as ex:
    #     logging.error(f"Error connecting to Azure Service Bus: {ex}")
    #     return func.HttpResponse(
    #         body=f"An error occurred while connecting to Azure Service Bus: {ex}",
    #         status_code=500
    #     )

    finally:
        # Close the client to avoid resource leaks
        logging.info("Close all connections here")
        #client.close_all_connections()

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully. ServiceBusConnection {serviceBusConnection}")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response. ServiceBusConnection {serviceBusConnection} ",
             status_code=200
        )