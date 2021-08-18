import 'dart:convert';

import 'package:courseplease/screens/webview/webview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class SignInWebViewScreen {
  final String uri;

  SignInWebViewScreen({
    required this.uri,
  });

  static Future<SignInWebViewResult> show({
    required BuildContext context,
    required String url,
  }) async {
    final message = await WebViewScreen.show(
      context: context,
      url: url,
      title: Text(tr('SignInWebViewScreen.title')),
    );

    if (message == null) return _getErrorResult();
    final map = jsonDecode(message);

    return map['return'] == 'ok'
        ? _getOkResult()
        : _getErrorResult();
  }

  static SignInWebViewResult _getErrorResult() {
    return SignInWebViewResult(
      status: SignInWebViewStatus.error,
    );
  }

  static SignInWebViewResult _getOkResult() {
    return SignInWebViewResult(
      status: SignInWebViewStatus.ok,
    );
  }
}

class SignInWebViewResult {
  final SignInWebViewStatus status;

  SignInWebViewResult({
    required this.status,
  });
}

enum SignInWebViewStatus {
  ok,
  error,
}
