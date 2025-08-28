package com.devzees.ai.models;
public class AIModel {
    private String name;
    private boolean enabled;
    private String icon;

    public AIModel(String name, boolean enabled, String icon) {
        this.name = name;
        this.enabled = enabled;
        this.icon = icon;
    }

    // getters and setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
}