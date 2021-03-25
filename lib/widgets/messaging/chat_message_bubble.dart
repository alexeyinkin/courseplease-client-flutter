import 'package:bubble/bubble.dart';
import 'package:courseplease/widgets/messaging/chat_message_body.dart';
import 'package:flutter/material.dart';
import 'chat_message_interface.dart';

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
          child: ChatMessageBodyWidget(message: message),
        ),
      ),
    );
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
          child: ChatMessageBodyWidget(message: message),
        ),
      ),
    );
  }
}
