package ch.swisscard.arc.scap;


import ch.swisscard.dipws.common.kubernetes.EnableDipWsKubernetes;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@EnableDipWsKubernetes
public class Main {

  public static void main(String[] args) {
    SpringApplication.run(Main.class, args);
  }
}