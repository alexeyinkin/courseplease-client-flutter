import 'package:courseplease/models/user.dart';
import 'package:courseplease/widgets/messaging/chat_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:flutter/widgets.dart';

import '../abstract_object_tile.dart';
import 'chat_message_body.dart';

class ChatMessageTile extends AbstractObjectTile<int, ChatMessage, ChatMessageFilter> {
  final User currentUser;

  ChatMessageTile({
    required TileCreationRequest<int, ChatMessage, ChatMessageFilter> request,
    required this.currentUser,
  }) : super(
    request: request,
  );

  @override
  _ChatMessageTileState createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends AbstractObjectTileState<int, ChatMessage, ChatMessageFilter, ChatMessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: _getChatMessageBubble(),
    );
  }

  Widget _getChatMessageBubble() {
    final message = widget.object;

    if (message.senderUserId == widget.currentUser.id) {
      return MyChatMessageBubble(message: message);
    }

    if (message.senderUserId != null) {
      return OthersChatMessageBubble(message: message);
    }

    return ChatMessageBody(message: message); // TODO: Fancy system messages as well.
  }
}
