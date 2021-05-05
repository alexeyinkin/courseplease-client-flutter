import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnknownMessageBodyPreviewWidget extends StatelessWidget {
  final MessageBody body;

  UnknownMessageBodyPreviewWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        tr('UnknownMessageBodyPreviewWidget.text'),
        style: AppStyle.italic,
      ),
    );
  }
}
