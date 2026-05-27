package com.dogbreeds;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(exclude = {
    org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration.class
})
public class DogBreedsApplication {
    public static void main(String[] args) {
        SpringApplication.run(DogBreedsApplication.class, args);
    }
}
