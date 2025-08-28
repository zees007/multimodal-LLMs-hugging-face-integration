package com.devzees.ai.configurations;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.deepseek.DeepSeekChatModel;
import org.springframework.ai.huggingface.HuggingfaceChatModel;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AIModelsConfig {

    @Value("${spring.ai.huggingface.chat.api-key}")
    private String huggingFaceApiKey;

    @Value("${spring.ai.huggingface.chat.url}")
    private String huggingFaceBaseUrl;


    @Value("${app.models.first.name}")
    private String firstModelName;

    @Value("${app.models.second.name}")
    private String secondModelName;

    @Bean
    public HuggingfaceChatModel firstLocalModel() {
        String url = huggingFaceBaseUrl + firstModelName;
        return new HuggingfaceChatModel(huggingFaceApiKey, url);
    }

    @Bean
    public HuggingfaceChatModel secondLocalModel() {
        String url = huggingFaceBaseUrl + secondModelName;
        return new HuggingfaceChatModel(huggingFaceApiKey, url);
    }

    @Bean
    public ChatClient openAIChatClient(OpenAiChatModel chatModel){
        return ChatClient.create(chatModel);
    }

    @Bean
    public ChatClient deepseekChatClient(DeepSeekChatModel chatModel){
        return ChatClient.create(chatModel);
    }

}
