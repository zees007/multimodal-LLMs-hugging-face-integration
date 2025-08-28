import 'package:flutter/material.dart';
import '../core/config/theme.dart';
import '../features/chat/chat_module.dart';
import '../features/settings/settings_module.dart';

class ChatEnterpriseApp extends StatelessWidget {
  const ChatEnterpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Multimodel Chat Buddy",
      theme: AppTheme.darkTheme,
      initialRoute: ChatRoutes.chat,
      routes: {
        ChatRoutes.chat: (_) => const ChatPage(),
        SettingsRoutes.settings: (_) => const SettingsPage(),
      },
    );
  }
}
