package digital.alf.demo_consume_api_wsl;

import digital.alf.demo_consume_api_wsl.soap.SoapClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class ApiHello {

    public static final String URL_SOAP_APIM = "https://alfdevapi7-example-apim.azure-api.net/suffix1";

    @Autowired
    private SoapClient soapClient;

    public static String APIM_SUBSCRIPTION= "98ceb311f9e148a5b57b8abeb81fe3fd";

    public static int VERSION = 2;

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
    public String triggerapirequest2() {
        Object request = new Object();
        Object res = soapClient.callWebService(URL_SOAP_APIM, request);
        return "End triggerapirequest2";
    }














//
//    @Bean
//    public WebServiceTemplate webServiceTemplate() {
//        WebServiceTemplate webServiceTemplate = new WebServiceTemplate();
//        webServiceTemplate.setMessageSender(new HttpUrlConnectionMessageSender());
//        return webServiceTemplate;
//    }
//
//    public String callSoapService(String url, String subscription, String requestBody) {
//        try {
//            String soapMessage = createSoapMessage(requestBody);
//            StreamSource source = new StreamSource(new StringReader(soapMessage));
//            StringWriter responseWriter = new StringWriter();
//
//            WebServiceTemplate webServiceTemplate = webServiceTemplate();
//
//            final SoapActionCallback requestCallbackMessage = new SoapActionCallback();
//            requestCallbackMessage.se
//
//            {
//
//
//                this.setSoapAction("AddMessage");
//                //((SoapMessage)message).getHeaders().add("subscription", subscription);
//            };
//
//            webServiceTemplate.sendSourceAndReceiveToResult(
//                    url,
//                    source,
//                    requestCallbackMessage,
//                    result -> {
//                        System.out.println(String.valueOf((Object)result);
//                        StreamSource streamSource = (StreamSource) result.getPayloadSource();
//                        StreamResult streamResult = new StreamResult(responseWriter);
//                        TransformerFactory.newInstance().newTransformer().transform(streamSource, streamResult);
//                    });
//
//            return responseWriter.toString();
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//
//    private String createSoapMessage(String requestBody) {
//        return "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://www.example.com/webservices\">" +
//                "<soapenv:Header/>" +
//                "<soapenv:Body>" +
//                requestBody +
//                "</soapenv:Body>" +
//                "</soapenv:Envelope>";
//    }

}

