package au.com.unico.vha;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.env.Environment;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@SpringBootApplication
@EnableConfigurationProperties
@ComponentScan
public class TestWebApplication extends SpringBootServletInitializer {
	
	private static Logger log = LoggerFactory.getLogger(TestWebApplication.class);

    public TestWebApplication() {
        // TODO Auto-generated constructor stub
    }

    public static void main(String[] args) throws Exception {
        SpringApplication app = new SpringApplication(TestWebApplication.class);
        Environment env = app.run(args).getEnvironment();

        log.info(
                "\n----------------------------------------------------------\n\t"
                        + "Filter API is running! Access URLs:\n\t"
                        + "Local: \t\thttp://localhost:{}\n\t"
                        + "Profile(s): \t{}\n----------------------------------------------------------",
                env.getProperty("server.port"), env.getActiveProfiles());
    }

    /**
     * This method is used when the application is deployed to an application container (like
     * tomcat)
     */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(TestWebApplication.class);
    }

}
