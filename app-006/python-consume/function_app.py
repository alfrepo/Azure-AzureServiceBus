import logging
import azure.functions as func

app = func.FunctionApp()


@app.service_bus_topic_trigger(arg_name="azservicebus", 
                               topic_name="alfdevapi6topic",
                               subscription_name="alfdevapi6subscription-1",
                               connection="ServiceBusConnection") 
def servicebus_trigger(azservicebus: func.ServiceBusMessage):
    logging.warn('Python ServiceBus Queue trigger processed a message: %s',
                azservicebus.get_body().decode('utf-8'))