package alf.digital.pub6.function;

import java.util.Optional;

import com.azure.messaging.servicebus.ServiceBusClientBuilder;
import com.azure.messaging.servicebus.ServiceBusMessage;
import com.azure.messaging.servicebus.ServiceBusSenderAsyncClient;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {

    final static String TOPIC_NAME_A = "alfdevapi6topic";
    // final static String CONN_STRING =

    final static String CONN_STRING_DEFAULT = "Endpoint=sb://alfdevapi6sb.servicebus.windows.net/;SharedAccessKeyName=alfdevapi6servicebus_auth_rule;SharedAccessKey=XXXXXXXXXXXXXXXXXXXX=";
    final static String CONN_STRING = Optional
            .ofNullable(System.getenv("ServiceBusConnection"))
            .orElse(CONN_STRING_DEFAULT);


    /**
     * This function System.getenv()
     * using "curl" command in bash:
     * 1. curl -d "HTTP Body" {your host}/api/HttpExample
     * 2. curl "{your host}/api/HttpExample?name=HTTP%20Query"
     */
    @FunctionName("HttpExample")
    public HttpResponseMessage run(
            @HttpTrigger(name = "req", methods = { HttpMethod.GET,
                    HttpMethod.POST }, authLevel = AuthorizationLevel.ANONYMOUS) HttpRequestMessage<Optional<String>> request,
            final ExecutionContext context) {
        context.getLogger().info("Java HTTP trigger processed a request.");

        // Parse query parameter
        final String query = request.getQueryParameters().get("name");
        final String name = request.getBody().orElse(query);

        sendMessage("Hi alf this is a message from Java azure function", "sessionid-008");

        if (name == null) {
            return request.createResponseBuilder(HttpStatus.BAD_REQUEST)
                    .body("Please pass a name on the query string or in the request body").build();
        } else {
            return request.createResponseBuilder(HttpStatus.OK).body("Hello, " + name).build();
        }
    }

    private static void sendMessage(String message, String sessionId) {
        // send to Azure Service Bus here

        // 'fullyQualifiedNamespace' will look similar to
        // "{your-namespace}.servicebus.windows.net"
        // 'disableAutoComplete' indicates that users will explicitly settle their
        // message.
        ServiceBusSenderAsyncClient asyncReceiver = new ServiceBusClientBuilder()
                .connectionString(CONN_STRING)
                .sender()
                .topicName(TOPIC_NAME_A)
                .buildAsyncClient();

        ServiceBusMessage serviceBusMessage = new ServiceBusMessage(message);
        serviceBusMessage.setSessionId(sessionId);

        asyncReceiver.sendMessage(serviceBusMessage);

        // When users are done with the receiver, dispose of the receiver.
        // Clients should be long-lived objects as they require resources
        // and time to establish a connection to the service.
        asyncReceiver.close();
    }
}
