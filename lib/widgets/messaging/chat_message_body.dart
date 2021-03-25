import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'chat_message_interface.dart';

class ChatMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;

  static const _insertDateWidth = 35.0;

  ChatMessageBodyWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: message.body.text,
              ),
              _getDateSpan(context),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: _ChatMessageBodyDateWidget(message: message),
        ),
      ],
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
        width: _insertDateWidth,
      ),
    );
  }

  InlineSpan _getNewLineDateSpace() {
    return TextSpan(text: '\n');
  }
}

class _ChatMessageBodyDateWidget extends StatelessWidget {
  final ChatMessageInterface message;

  _ChatMessageBodyDateWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message is ChatMessage) {
      return _SentChatMessageBodyDateWidget(message: message as ChatMessage);
    }

    if (message is SendingChatMessage) {
      return _SendingChatMessageBodyDateWidget(message: message as SendingChatMessage);
    }

    throw Exception('Unknown message class: ' + message.runtimeType.toString());
  }
}

class _SentChatMessageBodyDateWidget extends StatelessWidget {
  final ChatMessage message;

  _SentChatMessageBodyDateWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .2,
      child: (message.dateTimeEdit == null)
          ? _getInsertDateWidget(context)
          : _getEditDateWidget(context),
    );
  }

  Widget _getEditDateWidget(BuildContext context) {
    final whenParts = <String>[
      if (!areSameDay(message.dateTimeEdit!, message.dateTimeInsert))
        formatDate(message.dateTimeEdit!, requireLocale(context)),
      formatTime(message.dateTimeEdit!, requireLocale(context)),
    ];

    final when = whenParts.join(' ');
    final text = tr('ChatMessageBodyWidget.edited', namedArgs: {'when': when});
    return Text(
      text,
      style: AppStyle.minor,
    );
  }

  Widget _getInsertDateWidget(BuildContext context) {
    return Text(
      formatTime(message.dateTimeInsert, requireLocale(context)),
      style: AppStyle.minor,
      textAlign: TextAlign.end,
    );
  }
}

class _SendingChatMessageBodyDateWidget extends StatelessWidget {
  final SendingChatMessage message;

  _SendingChatMessageBodyDateWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    switch (message.status) {
      case SendingChatMessageStatus.failed:
        return Icon(
          Icons.error,
          color: AppStyle.errorColor,
          size: 15,
        );
      default:
        return InlineSmallCircularProgressIndicator(scale: .3);
    }
  }
}
