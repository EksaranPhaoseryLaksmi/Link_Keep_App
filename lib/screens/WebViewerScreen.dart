import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerScreen extends StatefulWidget {
  final String url;
  const WebViewerScreen({super.key, required this.url});

  @override
  State<WebViewerScreen> createState() => _WebViewerScreenState();
}

class _WebViewerScreenState extends State<WebViewerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          "Web View",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
