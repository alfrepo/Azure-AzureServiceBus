package digital.alf.demo_consume_api_wsl.soap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class YourService {

    @Autowired
    private SoapClient soapClient;

    public Object callSoapService() {
        Object request = new Object();
        return soapClient.callWebService("http://example.com/soapApi", request);
    }
}