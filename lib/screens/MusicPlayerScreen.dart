import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String url;
  const MusicPlayerScreen({super.key, required this.url});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
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
      appBar: AppBar(title: const Text("Music Player")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
