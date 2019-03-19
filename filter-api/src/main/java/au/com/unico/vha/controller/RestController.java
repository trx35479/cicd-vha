package au.com.unico.vha.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping(value = "test")
public class RestController {

    public RestController() {
        // TODO Auto-generated constructor stub
    }
    
    @GetMapping(value = "hello")
    public ResponseEntity<String> helloWorld() {
        return ResponseEntity.ok().body("Hello World!");
    }

}
