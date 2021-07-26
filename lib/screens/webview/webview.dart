import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final Widget title;
  final double? toolbarHeight;

  WebViewScreen({
    required this.url,
    required this.title,
    this.toolbarHeight,
  });

  static Future<String?> show({
    required BuildContext context,
    required String url,
    required Widget title,
    double? toolbarHeight,
  }) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewScreen(
          url: url,
          title: title,
          toolbarHeight: toolbarHeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      javascriptChannels: <JavascriptChannel>[
        JavascriptChannel(
          name: 'appWebview',
          onMessageReceived: (message) => _onMessageReceived(context, message),
        ),
      ].toSet(),
      appBar: AppBar(
        title: title,
        toolbarHeight: toolbarHeight,
      ),
    );
  }

  void _onMessageReceived(BuildContext context, JavascriptMessage message) {
    Navigator.of(context).pop(message.message);
  }
}
