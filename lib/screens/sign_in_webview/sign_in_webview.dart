import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SignInWebviewScreen extends StatefulWidget {
  static const routeName = '/signInWith';

  @override
  State<SignInWebviewScreen> createState() => _SignInWebviewScreenState();
}

class _SignInWebviewScreenState extends State<SignInWebviewScreen> {
  String _uri; // Nullable

  @override
  Widget build(BuildContext context) {
    _setUrlIfNot(context);

    return WebviewScaffold(
      url: _uri,
      appBar: AppBar(
        title: Text('Sign In :)'),
      ),
    );
  }

  void _setUrlIfNot(BuildContext context) {
    if (_uri != null) return;

    final arguments = ModalRoute.of(context).settings.arguments as SignInWebviewArguments;
    _uri = arguments.uri;
  }
}

class SignInWebviewArguments {
  final String uri;
  SignInWebviewArguments({
    @required this.uri,
  });
}
