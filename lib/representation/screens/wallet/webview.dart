import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String response;
  const WebView({super.key, required this.response});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;
  // final controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.disabled)
  //   ..loadRequest(Uri.parse(widget.response));

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.response));

    Future<void> checkUrl() async {
      while (true) {
        final url = await controller.currentUrl();
        if (url != null && url.contains('vnp_ResponseCode=00')) {
          // Đây là URL thành công của VNPAY
          // Thực hiện các hành động cần thiết, ví dụ: đóng WebView và hiển thị thông báo
          Navigator.pop(context); // Đóng WebView
          // Hiển thị màn hình thông báo thành công
          break;
        }
        // Chờ một thời gian nhất định trước khi kiểm tra lại URL
        await Future.delayed(Duration(seconds: 3));
      }
    }

    checkUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: WebView(response: response),
      body: WebViewWidget(controller: controller),
    );
  }
}
