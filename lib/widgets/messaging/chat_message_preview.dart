import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/refund_agree_message_body.dart';
import 'package:courseplease/models/messaging/refund_disagree_message_body.dart';
import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/circle_or_capsule.dart';
import 'package:courseplease/widgets/messaging/content_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/purchase_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/refund_agree_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/refund_disagree_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/refund_request_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/time_approve_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/time_offer_message_body_preview.dart';
import 'package:courseplease/widgets/messaging/unknown_message_body_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../pad.dart';
import '../user.dart';

/// Goes below chat name and date.
class ChatMessagePreviewWidget extends StatelessWidget {
  final Chat chat;
  final ChatMessage message;
  final User currentUser;

  ChatMessagePreviewWidget({
    required this.chat,
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final senderUser = _getSenderUser();

    return _getPreview(
      context: context,
      senderUser: senderUser,
      mineAndUnread: message.senderUserId == currentUser.id && message.dateTimeRead == null,
    );
  }

  User? _getSenderUser() {
    if (message.senderUserId == null) return null;
    if (message.senderUserId == currentUser.id) return currentUser;

    for (final user in chat.otherUsers) {
      if (user.id == message.senderUserId) {
        return user;
      }
    }

    throw Exception('User not found among chat participants: ' + message.senderUserId.toString());
  }

  Widget _getPreview({
    required BuildContext context,
    required User? senderUser,
    required bool mineAndUnread,
  }) {
    final children = <Widget>[];

    if (senderUser != null && senderUser.id == currentUser.id) {
      children.add(UserpicWidget(user: senderUser, size: 30));
    }
    children.add(
      Expanded(
        child: _getDecoratedContentPreview(mineAndUnread),
      ),
    );
    if (chat.unreadByMeCount > 0) {
      children.add(_getUnreadCountWidget(context));
    }

    return Row(
      children: alternateWidgetListWith(children, SmallPadding()),
    );
  }

  Widget _getDecoratedContentPreview(bool mineAndUnread) {
    final content = _getContentPreview();
    return mineAndUnread
        ? _MineAndUnreadContainer(child: content)
        : content;
  }

  Widget _getContentPreview() {
    final body = message.body;

    if (body is ContentMessageBody) {
      return ContentMessageBodyPreviewWidget(body: body);
    }

    if (body is PurchaseMessageBody) {
      return PurchaseMessageBodyPreviewWidget(body: body);
    }

    if (body is TimeOfferMessageBody) {
      return TimeOfferMessageBodyPreviewWidget(body: body);
    }

    if (body is TimeApproveMessageBody) {
      return TimeApproveMessageBodyPreviewWidget(body: body);
    }

    if (body is RefundRequestMessageBody) {
      return RefundRequestMessageBodyPreviewWidget(message: message, body: body);
    }

    if (body is RefundAgreeMessageBody) {
      return RefundAgreeMessageBodyPreviewWidget();
    }

    if (body is RefundDisagreeMessageBody) {
      return RefundDisagreeMessageBodyPreviewWidget();
    }

    return UnknownMessageBodyPreviewWidget(body: body);
  }

  Widget _getUnreadCountWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleOrCapsuleWidget(
      child: Text(
        chat.unreadByMeCount.toString(),
        style: TextStyle(
          color: colorScheme.onPrimary,
        ),
      ),
      color: colorScheme.primary,
    );
  }
}

class _MineAndUnreadContainer extends StatelessWidget {
  final Widget child;

  _MineAndUnreadContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppStyle.unreadColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: child,
    );
  }
}
