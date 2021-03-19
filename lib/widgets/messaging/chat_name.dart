import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/widgets.dart';

import '../user.dart';

class ChatNameWidget extends StatelessWidget {
  final Chat chat;

  ChatNameWidget({
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    switch (chat.otherUsers.length) {
      case 0:
        throw Exception('No other users in this chat.');
      case 1:
        return UserNameWidget(user: chat.otherUsers[0], style: AppStyle.bold);
    }
    throw Exception('Group chats are not supported. This chat has ' + chat.otherUsers.length.toString() + ' other users.');
  }
}
