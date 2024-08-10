package digital.alf.demo_consume_api_wsl;

import digital.alf.demo_consume_api_wsl.soap.LogHttpHeaderClientInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.ws.client.core.WebServiceTemplate;
import org.springframework.ws.client.support.interceptor.ClientInterceptor;

@Configuration
public class WebServiceConfig {

//    @Bean
//    public WebServiceTemplate webServiceTemplate() {
//        WebServiceTemplate webServiceTemplate = new WebServiceTemplate();
//        webServiceTemplate.setMessageSender(new HttpUrlConnectionMessageSender());
//        return webServiceTemplate;
//    }
    @Bean
    public WebServiceTemplate webServiceTemplate(Jaxb2Marshaller marshaller) {
        WebServiceTemplate webServiceTemplate = new WebServiceTemplate();
        webServiceTemplate.setMarshaller(marshaller);
        webServiceTemplate.setUnmarshaller(marshaller);

        // register the LogHttpHeaderClientInterceptor
        ClientInterceptor[] interceptors =
                new ClientInterceptor[] {new LogHttpHeaderClientInterceptor()};
        webServiceTemplate.setInterceptors(interceptors);

        // Configure other properties as needed
        return webServiceTemplate;
    }

    @Bean
    public Jaxb2Marshaller marshaller() {
        Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
        // Set this to the package name of your generated domain objects
        marshaller.setContextPath("digital.alf.gen.apim1");

        // avoid
        // https://stackoverflow.com/questions/6017146/jaxbrepresentation-gives-error-doesnt-contain-objectfactory-class-or-jaxb-index
        //marshaller.setContextPaths("", "");
        return marshaller;
    }





}