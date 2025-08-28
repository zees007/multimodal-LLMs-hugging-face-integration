package com.devzees.ai.controllers;

import com.devzees.ai.exceptions.ModelInterfaceProviderException;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.huggingface.HuggingfaceChatModel;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/huggingFace")
public class HuggingFaceAIController {


    private final HuggingfaceChatModel firstLocalModel;
    private final HuggingfaceChatModel secondLocalModel;

    public HuggingFaceAIController(@Qualifier("firstLocalModel") HuggingfaceChatModel firstLocalModel,
                                   @Qualifier("secondLocalModel") HuggingfaceChatModel secondLocalModel) {
        this.firstLocalModel = firstLocalModel;
        this.secondLocalModel = secondLocalModel;
    }

    @GetMapping("/firstLocalModelchat")
    public String chatWithFirstModel(@RequestParam String topic){
        try{
            ChatResponse response1 = firstLocalModel.call(new Prompt(topic));
            return response1.getResult().getOutput().getText();
        } catch (Exception e){
            throw new ModelInterfaceProviderException("Requested LLM Model is not hosted on hugging face interface.");
        }

    }

    @GetMapping("/secondLocalModelchat")
    public String chatWithSecondModel(@RequestParam String topic){
        try{
            ChatResponse response1 = secondLocalModel.call(new Prompt(topic));
            return response1.getResult().getOutput().getText();
        } catch (Exception e){
            throw new ModelInterfaceProviderException("Requested LLM Model is not hosted on hugging face interface.");
        }
    }


}
