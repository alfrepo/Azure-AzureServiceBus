
    

## Materials

As in https://spring.io/guides/gs/producing-web-service


## SOAP Service configuration

wsdl
``` xml
<definitions name="PutMessageService"
             targetNamespace="http://spring.io/guides/gs-producing-web-service"
             xmlns="http://schemas.xmlsoap.org/wsdl/"
             xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
             xmlns:tns="http://spring.io/guides/gs-producing-web-service"
             xmlns:xsd="http://www.w3.org/2001/XMLSchema">

  <message name="PutMessageRequest">
    <part name="message" type="xsd:string"/>
  </message>

  <message name="PutMessageResponse">
    <part name="status" type="xsd:string"/>  </message>

  <portType name="PutMessagePort">
    <operation name="putMessage">
      <input message="tns:PutMessageRequest"/>
      <output message="tns:PutMessageResponse"/>
    </operation>
  </portType>

  <binding name="PutMessageBinding" type="tns:PutMessagePort">
    <soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
    <operation name="putMessage">
      <soap:operation soapAction="http://spring.io/guides/gs-producing-web-service/putMessage"/>
      <input>
        <soap:body use="literal" namespace="http://spring.io/guides/gs-producing-web-service"/>
      </input>
      <output>
        <soap:body use="literal" namespace="http://spring.io/guides/gs-producing-web-service"/>
      </output>
    </operation>
  </binding>

  <service name="PutMessageService">
    <documentation>Put Message Web Service</documentation>
    <port binding="tns:PutMessageBinding" name="PutMessagePort">
      <soap:address location="http://your-service-address/PutMessage"/>  
    </port>
  </service>

</definitions>
```




request.xml
``` xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				  xmlns:gs="http://spring.io/guides/gs-producing-web-service">
   <soapenv:Header/>
   <soapenv:Body>
      <gs:putMessageRequest>
         <gs:message>MyMessage</gs:message>
      </gs:putMessageRequest>
   </soapenv:Body>
</soapenv:Envelope>
```

`curl --header "content-type: text/xml" -d @request.xml http://localhost:8080/ws`


## Starting a receiving azure function

TODO