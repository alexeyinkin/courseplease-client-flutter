import 'package:bubble/bubble.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/widgets/messaging/chat_message_body.dart';
import 'package:flutter/material.dart';

class MyChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  MyChatMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Bubble(
        nip: BubbleNip.rightBottom,
        color: const Color(0x60808080),
        child: ChatMessageBody(message: message),
      ),
    );
  }
}

class OthersChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  OthersChatMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20),
      child: Bubble(
        nip: BubbleNip.leftBottom,
        color: Colors.transparent,
        child: ChatMessageBody(message: message),
      ),
    );
  }
}
