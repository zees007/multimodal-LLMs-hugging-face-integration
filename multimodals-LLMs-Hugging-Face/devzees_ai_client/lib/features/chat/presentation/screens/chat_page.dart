import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/chat_window.dart';
import '../../../settings/settings_module.dart';
import '../../../../core/api/api_service.dart';
import '../../../model/ai_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> chats = ["Chat 1", "Chat 2"];
  final TextEditingController _controller = TextEditingController();

  bool isCollapsed = false;
  int? _maximizedIndex;

  List<AIModel> models = [];
  List<AIModel> enabledModels = [];

  /// 💬 message history per model name
  final Map<String, List<String>> modelMessages = {};

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      final fetched = await ApiService.fetchModels();
      setState(() => models = fetched);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showModelDialog();
      });
    } catch (e) {
      debugPrint("Error fetching models: $e");
    }
  }

  void _showModelDialog() {
    final colors = Theme.of(context).colorScheme;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "ModelDialog",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        List<AIModel> tempModels = List.from(models);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  color: colors.surface,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Choose your favorite AI Models",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tempModels.length,
                            itemBuilder: (context, index) {
                              final model = tempModels[index];
                              return SwitchListTile(
                                secondary: CircleAvatar(
                                  backgroundImage: NetworkImage(model.icon),
                                  radius: 18,
                                  onBackgroundImageError: (_, __) {},
                                ),
                                title: Text(
                                  model.name,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                value: model.enabled,
                                onChanged: (val) {
                                  setDialogState(() {
                                    model.enabled = val;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();

                              final fetchedEnabled =
                              await ApiService.submitModels(tempModels);

                              setState(() {
                                models = tempModels;
                                enabledModels = fetchedEnabled;

                                // 🔄 reset message maps
                                modelMessages.clear();
                                for (final m in enabledModels) {
                                  modelMessages[m.name] = [];
                                }
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Models submitted ✅"),
                                ),
                              );
                            },
                            child: const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _newChat() {
    setState(() {
      chats.add("Chat ${chats.length + 1}");
    });
  }

  void _toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  /// 🚀 Send one prompt to all enabled models
  Future<void> _sendPromptToAll() async {
    final topic = _controller.text.trim();
    if (topic.isEmpty) return;

    for (final model in enabledModels) {
      try {
        final response = await ApiService.sendPrompt(model, topic);

        setState(() {
          modelMessages[model.name] ??= [];
          modelMessages[model.name]!.add("🧑 You: $topic");
          modelMessages[model.name]!.add("🤖 ${model.name}: $response");
        });
      } catch (e) {
        setState(() {
          modelMessages[model.name] ??= [];
          modelMessages[model.name]!.add("⚠️ Error: $e");
        });
      }
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // 🔹 Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isCollapsed ? 60 : 220,
            color: colors.surface,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      isCollapsed
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.white70,
                      size: 18,
                    ),
                    onPressed: _toggleSidebar,
                  ),
                ),
                if (!isCollapsed)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton.icon(
                      onPressed: _newChat,
                      icon: const Icon(Icons.add),
                      label: const Text("New Chat"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.surface,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                  )
                else
                  IconButton(
                    onPressed: _newChat,
                    icon: const Icon(Icons.add, color: Colors.tealAccent),
                  ),
                const Divider(color: Colors.grey),
                Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.chat_bubble_outline,
                            color: Colors.tealAccent),
                        title: isCollapsed
                            ? null
                            : Text(
                          chats[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: isCollapsed
                      ? null
                      : const Text("Settings",
                      style: TextStyle(color: Colors.grey)),
                  onTap: () =>
                      Navigator.pushNamed(context, SettingsRoutes.settings),
                ),
              ],
            ),
          ),

          // 🔸 Main chat area
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (_maximizedIndex == null)
                        enabledModels.isEmpty
                            ? const Center(
                          child: Text(
                            "No models enabled yet",
                            style: TextStyle(
                                color: Colors.grey, fontSize: 18),
                          ),
                        )
                            : Row(
                          children: List.generate(
                            enabledModels.length,
                                (index) {
                              final model = enabledModels[index];
                              return Expanded(
                                child: ChatWindow(
                                  model: model,
                                  messages:
                                  modelMessages[model.name] ?? [],
                                  onMaximize: () {
                                    setState(() =>
                                    _maximizedIndex = index);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      if (_maximizedIndex != null)
                        Positioned.fill(
                          child: ChatWindow(
                            model: enabledModels[_maximizedIndex!],
                            messages: modelMessages[
                            enabledModels[_maximizedIndex!].name] ??
                                [],
                            isMaximized: true,
                            onCloseMaximize: () {
                              setState(() => _maximizedIndex = null);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black87,
                  child: CustomTextField(
                    controller: _controller,
                    hint: "Type your prompt here...",
                    onSend: _sendPromptToAll,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
