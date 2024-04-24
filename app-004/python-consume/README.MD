
## Configuring the function

To configure the function

in **local.settings.json**

set ServiceBusConnection to point to your service bus
```
"ServiceBusConnection": "Endpoint=sb://alfdevapi3sb.servicebus.windows.net/;SharedAccessKeyName=alfdevapi3servicebus_auth_rule;SharedAccessKey=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```




## Run function


``` shell
# run the function
func start --verbose

# call now
curl http://localhost:7071/api/http_trigger?name=Alex
```

