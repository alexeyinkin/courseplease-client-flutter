import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UnknownMessageBodyWidget extends StatelessWidget {
  final MessageBody body;

  UnknownMessageBodyWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        tr('UnknownMessageBodyWidget.text'),
        style: AppStyle.italic,
      ),
    );
  }
}
