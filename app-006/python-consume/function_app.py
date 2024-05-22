import logging
import azure.functions as func
import os

app = func.FunctionApp()

TOPIC_NAME_A = os.environ['Topic']
#CONN_STRING = os.environ['ServiceBusConnection']
SESSION_ID = os.environ['SessionId']


@app.service_bus_topic_trigger(arg_name="azservicebus", 
                               topic_name=TOPIC_NAME_A,
                               subscription_name="alfdevapi6subscription",
                               connection="ServiceBusConnection") 
def servicebus_trigger(azservicebus: func.ServiceBusMessage):
    logging.warn('Python ServiceBus Queue trigger processed a message: %s',
                azservicebus.get_body().decode('utf-8'))


