import logging
import azure.functions as func
from datetime import datetime


app = func.FunctionApp()

# vs output into queue for python
# https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-output?tabs=python-v2%2Cisolated-process%2Cnodejs-v4%2Cextensionv5&pivots=programming-language-python


@app.route(route="http_trigger_topic", auth_level=func.AuthLevel.ANONYMOUS)
@app.service_bus_topic_output(arg_name="message",
                              connection="ServiceBusConnection",
                              topic_name="alfdevapi6topic")
def http_trigger_topic(req: func.HttpRequest, message: func.Out[str]) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    myMessage = "Hi alf this is my message via the queue to you."
    logging.info(myMessage)
    
    input_msg = req.params.get('message')

    now = datetime.now()
    print("now =", now)

    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

    message.set(f"{myMessage}. Published at {now}")

    return func.HttpResponse(
        "This function should process queue messages.",
        status_code=200
    )

