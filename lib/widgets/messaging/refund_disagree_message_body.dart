import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/messaging/date_push.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefundDisagreeMessageBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tr('RefundDisagreeMessageBodyPreviewWidget.text'),
          style: AppStyle.italic,
        ),
        DatePushWidget(),
      ],
    );
  }
}
