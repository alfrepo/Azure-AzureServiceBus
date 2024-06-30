# How to use

## Deploy

To deploy the project:

    bash run.sh

There is a strange bug.
On the first deployment you will receive:

```
"Backend: "..."): unexpected status 400 with error: ValidationError: One or more fields contain incorrect values"
```

### Fix "unexpected status 400"

For some reason it helps to manually 

 - select the "API manager"
 - click "Add API"
 - select "Function App"
 - now add select your "Azure function"
 - after deploying : click on the new api, select "Test", then click "Send"

 Now the project will deploy correctly.



## TODO



 - WONT FIX move the policy, backend from "all operations" the GET operation level
 - DONE make the api redeployment - also deploy the code and http_trigger. At he moment the code disapears when redeployed
 - DONE add CORS origin * https://stackoverflow.com/questions/62040830/azure-api-management-origin-header-was-missing-or-empty-and-the-request-was-cl

 - DONE add a "azure service bus queue"
 - DONE make python function send a message to the queue
 - DONE run functions locally and see them receiving the message

- DONE fix the "http_trigger" which is missing after deployment
    The reason was - invalid import of ServiceBus. Seems to be somehow incompatible with triggers.
    Maybe the imports were from v1 model and triggers-annotation from v2 model?
    Try to use func.Servicebus from azure-function import, to send queue messages

- DONE integrate api-manager API directly with azure-service-bus-topic 
    - see https://byalexblog.net/article/azure-apimanagement-to-azure-service-bus/

- TODO validate the integration of REST api and azureservice bus via policies

- TODO 
    try code with in resource_apimanager.tf
    resource "azurerm_role_assignment" "apim_role_assignment"

 TODO
    - check if you can use "func.ServiceBusMessage" instead of importing serviceBus

- deploy hello-world SOAP API via Terraform (api.wsdl)
- deploy a SOAP api instead of REST API

 - use topics/ sessions, to validate FIFO ability of Azure Service Bus 
    https://learn.microsoft.com/en-us/azure/service-bus-messaging/message-sessions


- improve the SOAP api to receive a message, 
    AND turn message into a topic on azure-service-bus
- test via "curl SOAP request"
- receive the message via example "azure-function"