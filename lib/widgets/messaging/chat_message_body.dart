import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChatMessageBody extends StatelessWidget {
  final ChatMessage message;

  ChatMessageBody({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: message.body.text + '  ',
            ),
            _getDateSpan(context),
          ],
        ),
      ),
    );
  }

  InlineSpan _getDateSpan(BuildContext context) {
    if (message.dateTimeEdit != null) {
      return _getEditDateSpan(context);
    }
    return _getInsertDateSpan(context);
  }

  InlineSpan _getInsertDateSpan(BuildContext context) {
    return WidgetSpan(
      child: Opacity(
        opacity: .5,
        child: Text(
          formatTime(message.dateTimeInsert, requireLocale(context)),
          style: AppStyle.minor,
        ),
      ),
    );
  }

  InlineSpan _getEditDateSpan(BuildContext context) {
    // TODO: Show on a separate line to emphasize the edit.
    return WidgetSpan(
      child: Opacity(
        opacity: .5,
        child: Row(
          children: [
            Icon(Icons.edit, size: 12),
            Text(
              ' ' + formatTime(message.dateTimeInsert, requireLocale(context)),
              style: AppStyle.minor,
            ),
          ],
        ),
      ),
    );
  }
}
