import 'package:courseplease/models/user.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:flutter/widgets.dart';

import '../abstract_object_tile.dart';

class ChatMessageTile extends AbstractObjectTile<int, ChatMessage, ChatMessageFilter> {
  final User currentUser;

  ChatMessageTile({
    @required TileCreationRequest<int, ChatMessage, ChatMessageFilter> request,
    @required this.currentUser,
  }) : super(
    request: request,
  );

  @override
  _ChatMessageTileState createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends AbstractObjectTileState<int, ChatMessage, ChatMessageFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
    );
  }
}
