package digital.alf.demo_consume_api_wsl;

import org.springframework.boot.SpringApplication;

public class TestDemoConsumeApiWslApplication {

	public static void main(String[] args) {
		SpringApplication.from(DemoConsumeApiWslApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
