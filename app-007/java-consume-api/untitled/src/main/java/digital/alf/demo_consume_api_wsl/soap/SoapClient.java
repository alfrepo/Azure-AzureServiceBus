package digital.alf.demo_consume_api_wsl.soap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

@Component
public class SoapClient extends WebServiceGatewaySupport {

    @Autowired
    WebServiceTemplate webServiceTemplate;

    public Object callWebService(String url, Object request) {
        return webServiceTemplate.marshalSendAndReceive(url, request);
    }
}