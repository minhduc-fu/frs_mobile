import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frs_mobile/representation/screens/wallet/wallet_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String response;
  const WebView({super.key, required this.response});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.response));

    checkUrl();
  }

  Future<void> checkUrl() async {
    while (true) {
      final url = await controller.currentUrl();
      if (url != null && url.contains('vnp_ResponseCode=00')) {
        await Future.delayed(Duration(seconds: 5));
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          Navigator.popUntil(
              context, ModalRoute.withName(WalletScreen.routeName));
        }

        Navigator.of(context).pushReplacement(CupertinoPageRoute(
          builder: (context) => WalletScreen(),
        ));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: WebView(response: response),
      body: WebViewWidget(controller: controller),
    );
  }
}
