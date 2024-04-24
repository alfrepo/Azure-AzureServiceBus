import logging
import azure.functions as func
from azure.servicebus import ServiceBusClient, ServiceBusMessage

app = func.FunctionApp()

# consuming function
#see 
# https://stackoverflow.com/questions/77637034/python-azure-function-service-bus-queue-trigger-doesnt-work

@app.function_name(name="ServiceBusQueueTrigger1")
@app.service_bus_queue_trigger(arg_name="msg", 
                               queue_name="alfdevapi4servicebusqueue", 
                               connection="ServiceBusConnection")
def main(msg: func.ServiceBusMessage):
    try:
        # Retrieve message content
        message_content = msg.get_body().decode('utf-8')
        
        # Log the message content
        logging.info(f"Python ServiceBus queue trigger processed message: {message_content}")
        
        # Add your code here to process the message
        # For example, you could store it in a database, call another service, etc.
        # ...
    except Exception as ex:
        logging.error(f"Error processing message: {ex}")
