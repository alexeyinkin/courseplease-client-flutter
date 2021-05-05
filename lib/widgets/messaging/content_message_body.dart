import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:flutter/material.dart';

import 'chat_message_interface.dart';

class ContentMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final ContentMessageBody body;
  final double inlineDateWidth;

  ContentMessageBodyWidget({
    required this.message,
    required this.body,
    required this.inlineDateWidth,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: body.text,
          ),
          _getDateSpan(context),
        ],
      ),
    );
  }

  InlineSpan _getDateSpan(BuildContext context) {
    final message = this.message;
    if (message is ChatMessage && message.dateTimeEdit != null) {
      return _getNewLineDateSpace();
    }

    return _getInlineDateSpace();
  }

  InlineSpan _getInlineDateSpace() {
    return WidgetSpan(
      child: Container(
        width: inlineDateWidth,
      ),
    );
  }

  InlineSpan _getNewLineDateSpace() {
    return TextSpan(text: '\n');
  }
}
