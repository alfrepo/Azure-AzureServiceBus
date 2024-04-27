import logging
import azure.functions as func

app = func.FunctionApp()

# consuming function
#see 
# https://stackoverflow.com/questions/77637034/python-azure-function-service-bus-queue-trigger-doesnt-work

# @app.function_name(name="ServiceBusQueueTrigger1")
# @app.service_bus_queue_trigger(arg_name="msg", 
#                                queue_name="alfdevapi4servicebusqueue", 
#                                connection="ServiceBusConnection")
# def main(msg: func.ServiceBusMessage):
#     try:
#         # Retrieve message content
#         message_content = msg.get_body().decode('utf-8')
        
#         # Log the message content
#         logging.info(f"Python ServiceBus queue trigger processed message: {message_content}")
        
#         # Add your code here to process the message
#         # For example, you could store it in a database, call another service, etc.
#         # ...
#     except Exception as ex:
#         logging.error(f"Error processing message: {ex}")


@app.route(route="http_trigger", auth_level=func.AuthLevel.ANONYMOUS)
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    return func.HttpResponse(
        "This function should process queue messages.",
        status_code=200
    )



@app.service_bus_queue_trigger(arg_name="azservicebus", queue_name="alfdevapi5servicebusqueue",
                               connection="ServiceBusConnection") 
def servicebus_trigger(azservicebus: func.ServiceBusMessage):
    logging.info('Python ServiceBus Queue trigger processed a message: %s',
                azservicebus.get_body().decode('utf-8'))