package digital.alf.demo_consume_api_wsl.soap;

import org.springframework.stereotype.Component;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

@Component
public class SoapClient extends WebServiceGatewaySupport {

    public Object callWebService(String url, Object request) {
        return getWebServiceTemplate().marshalSendAndReceive(url, request);
    }
}