class AIModel {
  final String name;
  bool enabled;
  final String icon;

  AIModel({required this.name, required this.enabled, required this.icon});

  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      name: json['name'],
      enabled: json['enabled'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "enabled": enabled,
    "icon": icon,
  };
}
