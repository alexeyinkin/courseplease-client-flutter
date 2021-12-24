import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/widgets/messaging/chat_avatar.dart';
import 'package:courseplease/widgets/messaging/chat_message_list.dart';
import 'package:courseplease/widgets/messaging/chat_name.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class ChatMessageListScreen extends StatelessWidget {
  final Chat chat;
  final ChatMessageFilter chatMessageFilter;

  ChatMessageListScreen({
    required this.chat,
    required this.chatMessageFilter,
  });

  static Future<void> show({
    required BuildContext context,
    required Chat chat,
    required ChatMessageFilter chatMessageFilter,
  }) {
    // TODO: Push to state instead. Cannot do it now because its pop is awaited.
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMessageListScreen(
          chat: chat,
          chatMessageFilter: chatMessageFilter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ChatAvatarWidget(chat: chat, size: 30),
            SmallPadding(),
            ChatNameWidget(chat: chat),
          ],
        ),
      ),
      body: ChatMessageListWidget(
        chat: chat,
        filter: chatMessageFilter,
        showTitle: false,
      ),
    );
  }
}
