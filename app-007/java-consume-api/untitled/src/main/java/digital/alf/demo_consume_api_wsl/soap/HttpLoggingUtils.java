package digital.alf.demo_consume_api_wsl.soap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ws.WebServiceMessage;
import org.springframework.xml.transform.TransformerObjectSupport;

import java.io.ByteArrayOutputStream;

public class HttpLoggingUtils extends TransformerObjectSupport {

  private static final Logger LOGGER = LoggerFactory.getLogger(HttpLoggingUtils.class);

  private static final String NEW_LINE = System.getProperty("line.separator");

  private HttpLoggingUtils() {}

  public static void logMessage(String id, WebServiceMessage webServiceMessage) {
    try {
      ByteArrayOutputStream byteArrayTransportOutputStream =
          new ByteArrayOutputStream();
      webServiceMessage.writeTo(byteArrayTransportOutputStream);

      String httpMessage = new String(byteArrayTransportOutputStream.toByteArray());
      LOGGER.info(NEW_LINE + "----------------------------" + NEW_LINE + id + NEW_LINE
          + "----------------------------" + NEW_LINE + httpMessage + NEW_LINE);
    } catch (Exception e) {
      LOGGER.error("Unable to log HTTP message.", e);
    }
  }
}