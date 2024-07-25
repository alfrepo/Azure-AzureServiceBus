## v2

This state successfully adds the managed identity "authorization header"

The API receives 

- via ``Request Body`` the data in this format: you pass a json ``{"addMessageRequestSchema":"<PASS_YOUR_EVENT_HERE_AND_ESCAPEIT>"}``


## Example PASS_YOUR_EVENT_HERE_AND_ESCAPEIT

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


you then need to escape JSON and pass the ``Request Body`` as following


``` json

{"addMessageRequestSchema": "{\r\n  \"specversion\" : \"1.0\",\r\n  \"type\" : \"com.github.pull_request.opened\",\r\n  \"source\" : \"https:\/\/github.com\/cloudevents\/spec\/pull\",\r\n  \"subject\" : \"123\",\r\n  \"id\" : \"A234-1234-1234\",\r\n  \"time\" : \"2018-04-05T17:31:00Z\",\r\n  \"comexampleextension1\" : \"value\",\r\n  \"comexampleothervalue\" : 5,\r\n  \"datacontenttype\" : \"text\/json\",\r\n  \"data\" : {\r\n      \"uriFile\": \"this\/is\/the\/blob\/reference\/to\/tsys\/file.json\",\r\n      \"uriFileSchema\": \"this\/is\/the\/blob\/reference\/to\/tsys\/fileschema.json\",         \r\n      \"system\": \"tsys\",\r\n      \"corelationid\": \"123\",\r\n      \"issuingTimeStamp\": \"2018-04-05T17:31:00Z\"\r\n\r\n  }\r\n}"}

```

Then the topic will receive a decoded JSON.