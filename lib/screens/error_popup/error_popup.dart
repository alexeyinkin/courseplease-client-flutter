import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/error/app_error.dart';
import 'package:flutter/material.dart';

class ErrorPopupScreen extends StatelessWidget {
  final String? text;

  static const _duration = Duration(seconds: 3);

  ErrorPopupScreen({
    this.text,
  });

  static void show({
    required BuildContext context,
    String? text,
  }) {
    showDialogWhile(
      () => showDialog(context: context, builder: (_) => ErrorPopupScreen(text: text)),
      Future.delayed(_duration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(30),
        child: AppErrorWidget(
          text: text,
        ),
      ),
    );
  }
}
