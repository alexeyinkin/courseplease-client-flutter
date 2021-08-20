import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../main.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final Widget title;
  final double? toolbarHeight;

  WebViewScreen({
    required this.url,
    required this.title,
    this.toolbarHeight,
  });

  static const _androidChromeAgent = 'Mozilla/5.0 (Linux; Android 8.1.0; SM-T585) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36';
  static const _androidFirefoxAgent = 'Mozilla/5.0 (Android 8.1.0; Mobile; rv:91.0) Gecko/91.0 Firefox/91.0';
  static const _linuxFirefoxAgent = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0';

  static Future<String?> show({
    required String url,
    required Widget title,
    double? toolbarHeight,
  }) async {
    return await navigatorKey.currentState!.push(
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
      userAgent: _androidFirefoxAgent,
    );
  }

  void _onMessageReceived(BuildContext context, JavascriptMessage message) {
    Navigator.of(context).pop(message.message);
  }
}
