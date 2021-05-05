import 'package:courseplease/models/messaging/message_body.dart';
import 'package:flutter/material.dart';

class ContentMessageBodyPreviewWidget extends StatelessWidget {
  final ContentMessageBody body;

  ContentMessageBodyPreviewWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      body.text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}
