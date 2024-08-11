## INtro
This folder contains the materials
for setting up the Azure API Manager in the required form,
so that SOAP API can be provided on it.

TODO
All that materials should become part of the Terraform.


## v3

This state successfully adds the managed identity "authorization header"

The API receives 

``` xml
<?xml version="1.0" encoding="utf-8"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
  <Body>
    <PutMessageRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.dataaccess.com/webservicesserver/">
      <message>YOUR_MESSAGE_JSON_IS_HERE</message>
    </PutMessageRequest>
  </Body>
</Envelope>
```


## Example YOUR_MESSAGE_JSON_IS_HERE

If you want to have an event in your topic like

``` json
{
  "specversion" : "1.0",
  "type" : "com.github.pull_request.opened",
  "source" : "https://github.com/cloudevents/spec/pull",
  "subject" : "123",
  "id" : "A234-1234-1234",
  "time" : "2018-04-05T17:31:00Z",
  "comexampleextension1" : "value",
  "comexampleothervalue" : 5,
  "datacontenttype" : "text/json",
  "data" : {
      "uriFile": "this/is/the/blob/reference/to/tsys/file.json",
      "uriFileSchema": "this/is/the/blob/reference/to/tsys/fileschema.json",         
      "system": "tsys",
      "corelationid": "123",
      "issuingTimeStamp": "2018-04-05T17:31:00Z"

  }
}

```


you DONT need to escape JSON to pass it as following.

(Escapiing will happen as part of the API-Manager policy. Probably part of XMLtoJSON coonversion.)


``` json

POST https://alfdevapi7-example-apim.azure-api.net/suffix1 HTTP/1.1
Host: alfdevapi7-example-apim.azure-api.net
Content-Type: text/xml
SOAPAction: "PutMessage"

<?xml version="1.0" encoding="utf-8"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
  <Body>
    <PutMessageRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.dataaccess.com/webservicesserver/">
      <message>{"specversion":"1.0","type":"com.github.pull_request.opened","source":"https://github.com/cloudevents/spec/pull","subject":"123","id":"A234-1234-1234","time":"2018-04-05T17:31:00Z","comexampleextension1":"value","comexampleothervalue":5,"datacontenttype":"text/json","data":{"uriFile":"this/is/the/blob/reference/to/tsys/file.json","uriFileSchema":"this/is/the/blob/reference/to/tsys/fileschema.json","system":"tsys","corelationid":"123","issuingTimeStamp":"2018-04-05T17:31:00Z"}}</message>
    </PutMessageRequest>
  </Body>
</Envelope>

```

Then the topic will receive a decoded JSON.



### Calling the API in POstman

The SOAP api on Azure API Manager can be called via PostMan.

Just store the followin as JSON and  import the following collection via `File > Import collection`


`Azure-Foundation.postman_collection_V3.json`
``` json
{
	"info": {
		"_postman_id": "0512d8d0-78da-45d8-9235-59921d6ae3a1",
		"name": "Azure-Foundation",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
		"_exporter_id": "4812615"
	},
	"item": [
		{
			"name": "post to APIM api redirecting to  Azure Servicebus",
			"protocolProfileBehavior": {
				"disabledSystemHeaders": {
					"content-type": true
				}
			},
			"request": {
				"method": "POST",
				"header": [
					{
						"key": "Content-Type",
						"value": "text/xml",
						"type": "text"
					},
					{
						"key": "SOAPAction",
						"value": "\"PutMessage\"",
						"type": "text"
					}
				],
				"body": {
					"mode": "raw",
					"raw": "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">\r\n  <Body>\r\n    <PutMessageRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.dataaccess.com/webservicesserver/\">\r\n      <message>{\"specversion\":\"1.0\",\"type\":\"com.github.pull_request.opened\",\"source\":\"https://github.com/cloudevents/spec/pull\",\"subject\":\"123\",\"id\":\"A234-1234-1234\",\"time\":\"2018-04-05T17:31:00Z\",\"comexampleextension1\":\"value\",\"comexampleothervalue\":5,\"datacontenttype\":\"text/json\",\"data\":{\"uriFile\":\"this/is/the/blob/reference/to/tsys/file.json\",\"uriFileSchema\":\"this/is/the/blob/reference/to/tsys/fileschema.json\",\"system\":\"tsys\",\"corelationid\":\"123\",\"issuingTimeStamp\":\"2018-04-05T17:31:00Z\"}}</message>\r\n    </PutMessageRequest>\r\n  </Body>\r\n</Envelope>\r\n\r\n",
					"options": {
						"raw": {
							"language": "json"
						}
					}
				},
				"url": {
					"raw": "https://alfdevapi7-example-apim.azure-api.net/suffix1",
					"protocol": "https",
					"host": [
						"alfdevapi7-example-apim",
						"azure-api",
						"net"
					],
					"path": [
						"suffix1"
					]
				}
			},
			"response": []
		}
	]
}
```