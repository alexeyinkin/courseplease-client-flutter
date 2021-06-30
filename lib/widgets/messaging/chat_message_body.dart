import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/refund_agree_message_body.dart';
import 'package:courseplease/models/messaging/refund_disagree_message_body.dart';
import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/purchase_message_body.dart';
import 'package:courseplease/widgets/messaging/refund_agree_message_body.dart';
import 'package:courseplease/widgets/messaging/refund_disagree_message_body.dart';
import 'package:courseplease/widgets/messaging/refund_request_message_body.dart';
import 'package:courseplease/widgets/messaging/time_approve_message_body.dart';
import 'package:courseplease/widgets/messaging/time_offer_message_body.dart';
import 'package:courseplease/widgets/messaging/unknown_message_body.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../models/messaging/chat_message_interface.dart';
import 'content_message_body.dart';

class ChatMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final ChatMessageShowReadStatus showReadStatus;

  static const _insertDateWidth = 35.0;
  static const _readIconWidth = 17.0;

  ChatMessageBodyWidget({
    required this.message,
    required this.showReadStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getContentWidget(context),
        _getDateWidget(),
        _getReadStatusWidget(),
      ],
    );
  }

  Widget _getContentWidget(BuildContext context) {
    final body = message.body;
    final inlineDateWidth = _getInlineDateWidth();

    if (body is ContentMessageBody) {
      return ContentMessageBodyWidget(
        message: message,
        body: body,
        inlineDateWidth: inlineDateWidth,
      );
    }

    if (body is PurchaseMessageBody) {
      return PurchaseMessageBodyWidget(
        message: message as ChatMessage,
        body: body,
      );
    }

    if (body is TimeOfferMessageBody) {
      return TimeOfferMessageBodyWidget(
        message: message,
        body: body,
      );
    }

    if (body is TimeApproveMessageBody) {
      return TimeApproveMessageBodyWidget(
        body: body,
      );
    }

    if (body is RefundRequestMessageBody) {
      return RefundRequestMessageBodyWidget(
        message: message,
        body: body,
      );
    }

    if (body is RefundAgreeMessageBody) {
      return RefundAgreeMessageBodyWidget(
        message: message,
      );
    }

    if (body is RefundDisagreeMessageBody) {
      return RefundDisagreeMessageBodyWidget();
    }

    return UnknownMessageBodyWidget(body: body);
  }

  double _getInlineDateWidth() {
    var width = _insertDateWidth;
    if (showReadStatus != ChatMessageShowReadStatus.noPlaceholder) {
      width += _readIconWidth;
    }
    return width;
  }

  Widget _getDateWidget() {
    return Positioned(
      right: showReadStatus == ChatMessageShowReadStatus.noPlaceholder ? 0 : _readIconWidth,
      bottom: 0,
      child: _ChatMessageBodyDateWidget(message: message),
    );
  }

  Widget _getReadStatusWidget() {
    switch (showReadStatus) {
      case ChatMessageShowReadStatus.noPlaceholder:
      case ChatMessageShowReadStatus.placeholder:
        return Container(width: 0, height: 0);

      case ChatMessageShowReadStatus.read:
      case ChatMessageShowReadStatus.unread:
        return Positioned(
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: .2,
            child: Icon(
              _getReadStatusIcon(),
              size: 13,
            ),
          )
        );
    }
    throw Exception('Unknown ShowChatMessageReadStatus: ' + showReadStatus.toString());
  }

  IconData _getReadStatusIcon() {
    switch (showReadStatus) {
      case ChatMessageShowReadStatus.read:
        return FlutterIcons.check_all_mco;
      case ChatMessageShowReadStatus.unread:
        return FlutterIcons.check_mco;
      case ChatMessageShowReadStatus.noPlaceholder:
      case ChatMessageShowReadStatus.placeholder:
        throw Exception('Should not get here.');
    }
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
    final edit = message.dateTimeEdit!.toLocal();
    final insert = message.dateTimeInsert.toLocal();
    final whenParts = <String>[
      if (!areSameDay(edit, insert)) formatDate(edit, requireLocale(context)),
      formatTime(edit, requireLocale(context)),
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
      formatTime(message.dateTimeInsert.toLocal(), requireLocale(context)),
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

enum ChatMessageShowReadStatus {
  noPlaceholder,
  placeholder,
  unread,
  read,
}
