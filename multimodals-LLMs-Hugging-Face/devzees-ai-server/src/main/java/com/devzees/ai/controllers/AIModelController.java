package com.devzees.ai.controllers;

import com.devzees.ai.models.AIModel;
import com.devzees.ai.services.AIModelService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.List;

@RestController
@RequestMapping("/api/v1/models")
public class AIModelController {
    private final AIModelService aiModelService;

    public AIModelController(AIModelService aiModelService) {
        this.aiModelService = aiModelService;
    }

    /**
     * Get all AI models
     * @return List of AiModel objects
     */
    @GetMapping
    public List<AIModel> getAllModels(HttpServletRequest request) {
        String baseUrl = ServletUriComponentsBuilder.fromRequestUri(request)
                .replacePath(null)
                .build()
                .toUriString();

        return aiModelService.getAllModels().stream()
                .map(m -> new AIModel(
                        m.getName(),
                        m.isEnabled(),
                        baseUrl + m.getIcon() // build absolute URL here
                ))
                .toList();
    }

    /**
     * Update enabled status of models
     * @param enabledModels List of model names to enable
     * @return HTTP 200 on success
     */
    @PostMapping("/enabled")
    public ResponseEntity<List<AIModel>> updateEnabledModels(
            @RequestBody List<String> enabledModels,
            HttpServletRequest request
    ) {
        List<AIModel> models = aiModelService.getEnabledModels(request, enabledModels);
        return ResponseEntity.ok(models);
    }
}