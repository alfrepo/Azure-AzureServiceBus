import logging
import azure.functions as func
from datetime import datetime
import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# vs output into queue for python
# https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-output?tabs=python-v2%2Cisolated-process%2Cnodejs-v4%2Cextensionv5&pivots=programming-language-python



@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    myMessage = "Hi alf this is my message via the queue to you."

    TOPIC_NAME_A = os.environ['Topic']
    CONN_STRING = os.environ['ServiceBusConnection']
    
    
    SESSION_ID = 'Session Disabled'
    # disable messages for now
    # SESSION_ID = os.environ['SessionId']

    logging.info(f'TOPIC_NAME_A {TOPIC_NAME_A}')
    logging.info(f'CONN_STRING {CONN_STRING}')
    logging.info(f'SESSION_ID {SESSION_ID}')


    jsn_message_envelope =  generateMessage(myMessage, SESSION_ID)
    logging.info(f"Will send envelope: {jsn_message_envelope}")

    servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONN_STRING)
    rith_sen = servicebus_client.get_topic_sender(TOPIC_NAME_A)
    rith_msg = ServiceBusMessage(jsn_message_envelope)

    # disable messages for now
    # rith_msg.session_id = SESSION_ID

    with rith_sen:
        rith_sen.send_messages(rith_msg)
    servicebus_client.close()


    return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
            status_code=200
    )


def generateMessage(myMessage, mySessionId):
    now = datetime.now()
    print("now =", now)
    logging.info(f"Time stamp: {now}")

    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

    my_json_string = f"""
    {{
        "body": "{myMessage}",
        "customProperties": {{
            "timePublish": "{dt_string}",
        }},
        "brokerProperties": {{
            "SessionId": "{mySessionId}"
        }}
    }}
    """

    return my_json_string

