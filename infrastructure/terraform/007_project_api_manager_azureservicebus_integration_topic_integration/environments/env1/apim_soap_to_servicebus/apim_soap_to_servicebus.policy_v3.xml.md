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