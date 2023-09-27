import 'package:demo_frs_app/representation/widgets/app_bar_container.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(child: Scaffold());
  }
}
