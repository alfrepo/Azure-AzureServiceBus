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
- make python function send a message to the queue
- make function be triggered by azure service bus
    - https://stackoverflow.com/questions/77637034/python-azure-function-service-bus-queue-trigger-doesnt-work