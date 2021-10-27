import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/widgets/messaging/chat_message_body.dart';
import 'package:flutter/material.dart';
import '../../models/messaging/chat_message_interface.dart';

class MyChatMessageBubble extends StatelessWidget {
  final ChatMessageInterface message;

  MyChatMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0x60808080),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ChatMessageBodyWidget(
          message: message,
          showReadStatus: _getShowReadStatus(message),
        ),
      ),
    );
  }

  ChatMessageShowReadStatus _getShowReadStatus(ChatMessageInterface message) {
    if (!(message is ChatMessage)) return ChatMessageShowReadStatus.placeholder;
    if (message.dateTimeRead != null) return ChatMessageShowReadStatus.read;
    return ChatMessageShowReadStatus.unread;
  }
}

class OthersChatMessageBubble extends StatelessWidget {
  final ChatMessageInterface message;

  OthersChatMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0x60808080)),
        ),
        child: ChatMessageBodyWidget(
          message: message,
          showReadStatus: ChatMessageShowReadStatus.noPlaceholder,
        ),
      ),
    );
  }
}
