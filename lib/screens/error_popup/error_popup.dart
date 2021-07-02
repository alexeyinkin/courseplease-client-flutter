import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/error/unknown_error.dart';
import 'package:flutter/material.dart';

class ErrorPopupScreen extends StatelessWidget {
  static const duration = Duration(seconds: 3);

  static void show(BuildContext context) {
    showDialogWhile(
      () => showDialog(context: context, builder: (_) => ErrorPopupScreen()),
      Future.delayed(duration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(30),
        child: UnknownErrorWidget(),
      ),
    );
  }
}
