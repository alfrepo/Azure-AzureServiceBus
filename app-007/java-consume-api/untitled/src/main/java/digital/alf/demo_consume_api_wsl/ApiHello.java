package digital.alf.demo_consume_api_wsl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import digital.alf.demo_consume_api_wsl.soap.SoapClient;
import digital.alf.gen.apim1.PutMessageRequest;
import jakarta.xml.soap.*;
import net.minidev.json.JSONObject;
import org.apache.tomcat.util.json.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.xml.namespace.QName;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Map;

@RestController
public class ApiHello {

    public static final String URL_SOAP_APIM = "https://alfdevapi7-example-apim.azure-api.net/suffix1";

    @Autowired
    private SoapClient soapClient;


    public static String APIM_SUBSCRIPTION= "98ceb311f9e148a5b57b8abeb81fe3fd";

    public static int VERSION = 3;

    // request JSON
    public static final String JSON_STRING = """
{
    "specversion": "1.0",
    "type": "com.github.pull_request.opened",
    "source": "https://github.com/cloudevents/spec/pull",
    "subject": "123",
    "id": "A234-1234-1234",
    "time": "2018-04-05T17:31:00Z",
    "comexampleextension1": "value",
    "comexampleothervalue": 5,
    "datacontenttype": "text/json",
    "data": {
        "uriFile": "this/is/the/blob/reference/to/tsys/file.json",
        "uriFileSchema": "this/is/the/blob/reference/to/tsys/fileschema.json",
        "system": "tsys",
        "corelationid": "123",
        "issuingTimeStamp": "2018-04-05T17:31:00Z"
    }
}
                """;

    @GetMapping("/")
    public String getVerison() {
        return DemoConsumeApiWslApplication.getVERSIONString();
    }

    @GetMapping("/public/hello/")
    public String helloWorld() {
        return "Hello World!";
    }

    @GetMapping("/public/hello/{name}/")
    public String helloWorldName(@PathVariable String name) {
        return String.format("Hi, %s!" , name);
    }

    @GetMapping("/public/triggerapirequest1/")
    public String triggerapirequest1() {

        // Define the URL
        String url = "https://alfdevapi7-example-apim.azure-api.net/path/servicebus/";

        // Create a RestTemplate object
        RestTemplate restTemplate = new RestTemplate();

        // Create HttpHeaders object
        HttpHeaders headers = new HttpHeaders();

        // Set the header "subscription" with the value
        headers.set("subscription", APIM_SUBSCRIPTION);

        // Create a HttpEntity object with headers
        HttpEntity<String> entity = new HttpEntity<>(null, headers);

        // Send the GET request and get the response
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

        // Check the response status code
        if ( HttpStatus.Series.SUCCESSFUL.equals(HttpStatus.Series.valueOf(response.getStatusCode().value()) ) ) {
            String body = response.getBody();
            System.out.println("Response body: " + body);
        } else {
            System.out.println("Error: " + response.getStatusCodeValue());
        }

        return "End triggerapirequest1";
    }

    @GetMapping("/public/triggerapirequest2/")
    public String triggerapirequest2() throws ParseException, JsonProcessingException {
        PutMessageRequest putMessageRequest = new PutMessageRequest();

        String validatedJsonString = getSoapBodyMessage();

        putMessageRequest.setMessage(validatedJsonString);

        String operation = "/?soapAction=PutMessage"; // Optional operation part
        String fullUrl = URL_SOAP_APIM + operation;

        //org.springframework.ws.soap.client.SoapFaultClientException: Error processing request: No such method: PutMessageRequest
        Object res = soapClient.callWebService(fullUrl, putMessageRequest);

        // Object res = soapClient.callWebService(URL_SOAP_APIM, request);
        return "End triggerapirequest2";
    }

    private static String getSoapBodyMessage() throws JsonProcessingException {
        // Parse JSON string into a Java object
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> parsedJson = objectMapper.readValue(JSON_STRING, Map.class);
        // Generate escaped JSON string
        String validatedJsonString = objectMapper.writeValueAsString(parsedJson);
        String escapedJsonString = JSONObject.escape(validatedJsonString);
        System.out.println(escapedJsonString);
        return validatedJsonString;
    }


    @GetMapping("/public/triggerapirequest3/")
    public String triggerapirequest3() throws ParseException, IOException, SOAPException {

        String operation = "/?soapAction=PutMessage"; // Optional operation part
        String fullUrl = URL_SOAP_APIM + operation;

        // Create a SOAP message
        MessageFactory messageFactory = MessageFactory.newInstance();
        SOAPMessage soapMessage = messageFactory.createMessage();
        SOAPPart soapPart = soapMessage.getSOAPPart();
        SOAPEnvelope envelope = soapPart.getEnvelope();


        // Set the namespace for the envelope
        envelope.addNamespaceDeclaration("soapenv", "http://schemas.xmlsoap.org/soap/envelope/");


        // Create the SOAP Body element
        SOAPBody body = envelope.getBody();

        // Define the namespace and name for PutMessageRequest
        QName putMessageRequestName = new QName("http://www.dataaccess.com/webservicesserver/",
                "PutMessageRequest", "da");

        // Create the PutMessageRequest element
        SOAPElement putMessageRequest = body.addChildElement(putMessageRequestName);

        // Add the "message" element with content
        SOAPElement messageElement = putMessageRequest.addChildElement(new QName("message"));
        messageElement.addTextNode("MyExampleMessage");

        System.out.println(messageElement.toString());

        // Send the SOAP message
        SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
        SOAPConnection connection = soapConnectionFactory.createConnection();

        URL endpoint = new URL(fullUrl);

        SOAPMessage response = connection.call(soapMessage, endpoint);

        // printing the response
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        response.writeTo(out);
        System.out.println(new String(out.toByteArray()));

        connection.close();


        // Object res = soapClient.callWebService(URL_SOAP_APIM, request);
        return "End triggerapirequest3";
    }


}

