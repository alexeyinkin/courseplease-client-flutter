import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DonePopupScreen extends StatelessWidget {
  static const _duration = Duration(seconds: 1);

  static void show(BuildContext context) {
    showDialogWhile(
      () => showDialog(context: context, builder: (_) => DonePopupScreen()),
      Future.delayed(_duration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(30),
        child: Container(
          child: Row(
            children: [
              Icon(Icons.check_circle),
              SmallPadding(),
              Text(tr('DonePopupScreen.text')),
            ],
          ),
        ),
      ),
    );
  }
}
