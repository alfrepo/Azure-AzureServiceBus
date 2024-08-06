package digital.alf.demo_consume_api_wsl;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiHello {

    public static int VERSION = 2;

    @GetMapping("/")
    public String getVerison() {
        return DemoConsumeApiWslApplication.getVERSIONString();
    }

    @GetMapping("/public/hello/")
    public String helloWorld() {
        return "Hello World!";
    }

    @GetMapping("/public/hello/{name}/")
    public String helloWorldName(@PathVariable String name) {
        return String.format("Hi, %s!" , name);
    }
}

