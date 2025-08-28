import 'package:flutter/material.dart';
import '../../../model/ai_model.dart';

class ChatWindow extends StatefulWidget {
  final AIModel model;
  final List<String> messages;
  final bool isMaximized;
  final VoidCallback? onMaximize;
  final VoidCallback? onCloseMaximize;

  const ChatWindow({
    super.key,
    required this.model,
    required this.messages,
    this.isMaximized = false,
    this.onMaximize,
    this.onCloseMaximize,
  });

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final ScrollController _scrollController = ScrollController();

  bool _isUserMessage(String msg) {
    return msg.startsWith("🧑");
  }

  @override
  void didUpdateWidget(covariant ChatWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto scroll to bottom when messages update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2E3145),
        border: Border(
          right: BorderSide(color: Colors.white24, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: colors.primary.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.model.icon),
                  radius: 14,
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.model.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (!widget.isMaximized)
                  IconButton(
                    onPressed: widget.onMaximize,
                    icon: const Icon(Icons.open_in_full,
                        size: 18, color: Colors.white70),
                  ),
                if (widget.isMaximized)
                  IconButton(
                    onPressed: widget.onCloseMaximize,
                    icon: const Icon(Icons.close_fullscreen,
                        size: 18, color: Colors.white70),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.white24),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                final isUser = _isUserMessage(msg);
                final displayMsg = msg.replaceFirst("🧑 You: ", "").replaceFirst("🤖 ", "").trim();

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isUser
                          ? colors.primary.withOpacity(0.8)
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      displayMsg,
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
