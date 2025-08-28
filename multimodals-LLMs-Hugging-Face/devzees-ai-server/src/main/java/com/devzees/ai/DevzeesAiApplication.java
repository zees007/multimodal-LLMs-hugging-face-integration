package com.devzees.ai;

import com.devzees.ai.configurations.AIModelProperties;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.deepseek.DeepSeekChatModel;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
@EnableConfigurationProperties({AIModelProperties.class})
public class DevzeesAiApplication {

	public static void main(String[] args) {
		SpringApplication.run(DevzeesAiApplication.class, args);
	}

}
