package digital.alf.demo_consume_api_wsl;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class DemoConsumeApiWslApplication {


	public static void main(String[] args) {
		SpringApplication.run(DemoConsumeApiWslApplication.class, args);
	}

}
