import logging
import azure.functions as func

app = func.FunctionApp()


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