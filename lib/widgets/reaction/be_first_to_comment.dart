import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BeFirstToCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Opacity(
          opacity: .3,
          child: Text(
            tr('CommentListWidget.beFirst'),
            style: AppStyle.h2,
          ),
        ),
      ),
    );
  }
}
