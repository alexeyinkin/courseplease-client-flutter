import 'package:bubble/bubble.dart';
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
        padding: EdgeInsets.only(left: 20),
        child: Bubble(
          nip: BubbleNip.rightBottom,
          padding: BubbleEdges.symmetric(horizontal: 7, vertical: 5),
          color: const Color(0x60808080),
          child: ChatMessageBodyWidget(
            message: message,
            showReadStatus: _getShowReadStatus(message),
          ),
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
        padding: EdgeInsets.only(right: 20),
        child: Bubble(
          nip: BubbleNip.leftBottom,
          padding: BubbleEdges.symmetric(horizontal: 7, vertical: 5),
          color: Colors.transparent,
          child: ChatMessageBodyWidget(
            message: message,
            showReadStatus: ChatMessageShowReadStatus.noPlaceholder,
          ),
        ),
      ),
    );
  }
}
