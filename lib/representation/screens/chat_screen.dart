import 'package:flutter/material.dart';
import '../../utils/asset_helper.dart';
import '../../utils/image_helper.dart';
import '../widgets/app_bar_main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = '/chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http')); // thay thế url của cậu vào
  }

  @override
  Widget build(BuildContext context) {
    return AppBarMain(
        titleAppbar: 'Chat',
        leading: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.8,
          child: ImageHelper.loadFromAsset(
            AssetHelper.imageLogoFRS,
          ),
        ),
        child: Scaffold(
          body: WebViewWidget(controller: controller),
        ));
  }
}
