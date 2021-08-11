import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String? text;

  AppErrorWidget({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.error),
          SmallPadding(),
          Text(text ?? tr('UnknownErrorWidget.text')),
        ],
      ),
    );
  }
}
