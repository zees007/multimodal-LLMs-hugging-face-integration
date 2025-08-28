import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../features/model/ai_model.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080/api/v1";

  static Future<List<AIModel>> fetchModels() async {
    final response = await http.get(Uri.parse("$baseUrl/models"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => AIModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load models");
    }
  }

  static Future<List<AIModel>> submitModels(List<AIModel> models) async {
    final enabledModels =
    models.where((m) => m.enabled).map((m) => m.name).toList();

    final response = await http.post(
      Uri.parse("$baseUrl/models/enabled"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(enabledModels),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AIModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to update enabled models");
    }
  }


  /// 🔥 NEW: Send prompt to respective API based on model name
  static Future<String> sendPrompt(AIModel model, String topic) async {
    String endpoint;

    switch (model.name.toLowerCase()) {
      case "openai":
        endpoint = "$baseUrl/openAI/chat";
        break;
      case "deepseek":
        endpoint = "$baseUrl/deepseek/chat";
        break;
      case "smollm3-3b":
        endpoint = "$baseUrl/huggingFace/firstLocalModelchat";
        break;
      case "dialogpt-large":
        endpoint = "$baseUrl/huggingFace/secondLocalModelchat";
        break;
      default:
        throw Exception("Unsupported model: ${model.name}");
    }

    final response =
    await http.get(Uri.parse(endpoint).replace(queryParameters: {"topic": topic}));

    if (response.statusCode == 200) {
      return response.body; // assuming plain text, adjust if JSON
    } else {
      throw Exception("Error from ${model.name}: ${response.body}");
    }
  }


}
