import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnknownErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.error),
          SmallPadding(),
          Text(tr('UnknownErrorWidget.text')),
        ],
      ),
    );
  }
}
