import logging
import azure.functions as func

app = func.FunctionApp()



@app.service_bus_queue_trigger(arg_name="azservicebus", queue_name="alfdevapi5servicebusqueue",
                               connection="ServiceBusConnection") 
def servicebus_trigger(azservicebus: func.ServiceBusMessage):
    logging.warn('Python ServiceBus Queue trigger processed a message: %s',
                azservicebus.get_body().decode('utf-8'))