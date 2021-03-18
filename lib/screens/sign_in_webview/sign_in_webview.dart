import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SignInWebviewScreen extends StatelessWidget {
  final String uri;

  SignInWebviewScreen({
    required this.uri,
  });

  static Future<void> show({
    required BuildContext context,
    required String uri,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => SignInWebviewScreen(
          uri: uri,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: uri,
      javascriptChannels: <JavascriptChannel>[
        JavascriptChannel(
          name: 'appWebview',
          onMessageReceived: (message) => _onMessageReceived(context, message),
        ),
      ].toSet(),
      appBar: AppBar(
        title: Text('Sign In :)'),
      ),
    );
  }

  void _onMessageReceived(BuildContext context, JavascriptMessage message) {
    final map = jsonDecode(message.message);

    Navigator.of(context).pop(
      SignInWebviewResult(
        status: map['return'] == 'ok' ? SignInWebviewStatus.ok : SignInWebviewStatus.error,
      ),
    );
  }
}

class SignInWebviewResult {
  final SignInWebviewStatus status;

  SignInWebviewResult({
    required this.status,
  });
}

enum SignInWebviewStatus {
  ok,
  error,
}
