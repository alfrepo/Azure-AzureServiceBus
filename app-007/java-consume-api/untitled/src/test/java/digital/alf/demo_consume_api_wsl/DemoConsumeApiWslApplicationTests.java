package digital.alf.demo_consume_api_wsl;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
class DemoConsumeApiWslApplicationTests {

	@Test
	void contextLoads() {
	}

}
