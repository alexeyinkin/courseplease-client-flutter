import 'package:courseplease/models/messaging/chat.dart';
import 'package:flutter/widgets.dart';

import '../user.dart';

class ChatAvatarWidget extends StatelessWidget {
  final Chat chat;
  final double size;

  ChatAvatarWidget({
    required this.chat,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    switch (chat.otherUsers.length) {
      case 0:
        throw Exception('No other users in this chat.');
      case 1:
        return UserpicWidget(user: chat.otherUsers[0], size: size);
    }
    throw Exception('Group chats are not supported. This chat has ' + chat.otherUsers.length.toString() + ' other users.');
  }
}
