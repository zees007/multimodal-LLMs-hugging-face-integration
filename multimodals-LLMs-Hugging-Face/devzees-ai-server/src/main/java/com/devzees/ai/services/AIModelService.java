package com.devzees.ai.services;

import com.devzees.ai.configurations.AIModelProperties;
import com.devzees.ai.models.AIModel;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class AIModelService {
    private final List<AIModel> models = new CopyOnWriteArrayList<>();
    private final AIModelProperties aiModelProperties;

    @Autowired
    public AIModelService(AIModelProperties aiModelProperties) {
        this.aiModelProperties = aiModelProperties;
        initializeModels();
    }


    private void initializeModels() {
        for (AIModelProperties.ModelConfig config : aiModelProperties.getModels()) {
            models.add(new AIModel(config.getName(), false, config.getIcon()));
        }
    }



    public List<AIModel> getAllModels() {
        return List.copyOf(models);
    }

    public List<AIModel> getEnabledModels(HttpServletRequest request, List<String> enabledModels) {
        if (enabledModels == null || enabledModels.isEmpty()) return List.of();

        // Build base URL dynamically from request
        String baseUrl = ServletUriComponentsBuilder.fromRequestUri(request)
                .replacePath(null)
                .build()
                .toUriString();

        return models.stream()
                .filter(m -> enabledModels.stream()
                        .anyMatch(name -> name.equalsIgnoreCase(m.getName())))
                .peek(m -> {
                    m.setEnabled(true);

                    // Make icon absolute path if it exists
                    if (m.getIcon() != null && !m.getIcon().startsWith("http")) {
                        m.setIcon(baseUrl + m.getIcon());
                    }
                })
                .toList();
    }

}