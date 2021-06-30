import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefundAgreeMessageBodyPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      tr('RefundAgreeMessageBodyPreviewWidget.text'),
      style: AppStyle.italic,
    );
  }
}
