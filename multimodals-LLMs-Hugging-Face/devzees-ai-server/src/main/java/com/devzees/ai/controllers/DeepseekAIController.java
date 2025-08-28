package com.devzees.ai.controllers;

import com.devzees.ai.exceptions.FreeModelCreditExhaustedException;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;


@RestController
@RequestMapping("/api/v1/deepseekAI")
public class DeepseekAIController {

    private final ChatClient chatClient;

    public DeepseekAIController(@Qualifier("deepseekChatClient") ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    @GetMapping("/chat")
    public String chat(@RequestParam String topic) {
        try {
            return chatClient.prompt()
                    .user(topic)
                    .call()
                    .content();
        } catch (Exception e) {
            throw new FreeModelCreditExhaustedException("You have exhausted your free credit limit. Subscribe to paid LLM Model.");
        }

    }

    @GetMapping("/stream")
    public Flux<String> streamChat(@RequestParam String topic){
        return chatClient.prompt()
                .user(topic)
                .stream()
                .content();
    }

    @GetMapping("/joke")
    public ChatResponse joke(){
        return chatClient.prompt()
                .user("Tell me about java facts.")
                .call()
                .chatResponse();
    }

}
