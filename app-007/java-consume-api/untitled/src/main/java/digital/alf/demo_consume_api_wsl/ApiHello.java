package digital.alf.demo_consume_api_wsl;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiHello {

    @GetMapping("/public/hello")
    public String helloWorld() {
        return "Hello World!";
    }
}

