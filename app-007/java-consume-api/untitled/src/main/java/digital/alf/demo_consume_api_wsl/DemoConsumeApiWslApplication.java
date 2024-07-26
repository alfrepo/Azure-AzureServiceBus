package digital.alf.demo_consume_api_wsl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoConsumeApiWslApplication implements CommandLineRunner {

	private static final Logger logger = LoggerFactory.getLogger(DemoConsumeApiWslApplication.class);


	public static int VERSION = 1;

	public static void main(String[] args) {
		SpringApplication.run(DemoConsumeApiWslApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		logger.info("Application started! "+getVERSIONString());
	}

	public static String getVERSIONString() {
		return String.format("Version: %s", VERSION);
	}
}
