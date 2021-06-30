import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  final Widget content;
  final String? okText;
  final String? cancelText;

  ConfirmScreen({
    required this.content,
    this.okText,
    this.cancelText,
  });

  static Future<bool> show({
    required BuildContext context,
    required Widget content,
    String? okText,
    String? cancelText,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ConfirmScreen(
        content: content,
        okText: okText,
        cancelText: cancelText,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        ElevatedButton(
          child: Text(cancelText ?? tr('ConfirmScreen.cancel')),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: Text(okText ?? tr('ConfirmScreen.ok')),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
