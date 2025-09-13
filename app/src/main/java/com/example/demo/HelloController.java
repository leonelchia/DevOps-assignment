package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.boot.info.GitProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

  @Autowired(required = false) BuildProperties build;
  @Autowired(required = false) GitProperties git;

  @GetMapping("/")
  public String home() {
    String pod     = System.getenv().getOrDefault("POD_NAME", "n/a");
    String node    = System.getenv().getOrDefault("NODE_NAME", "n/a");
    String ns      = System.getenv().getOrDefault("NAMESPACE", "n/a");
    String image   = System.getenv().getOrDefault("IMAGE_TAG", "n/a");

    return """
      <pre>
      Spring Boot on Kubernetes — it works!

      pod:     %s
      node:    %s
      ns:      %s
      image:   %s
      </pre>
      """.formatted( pod, node, ns, image);
  }
}
