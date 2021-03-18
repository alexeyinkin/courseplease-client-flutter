import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../abstract_object_tile.dart';
import '../pad.dart';
import '../user.dart';
import 'chat_message_preview.dart';

class ChatTile extends AbstractObjectTile<int, Chat, ChatFilter> {
  final User currentUser;

  ChatTile({
    required TileCreationRequest<int, Chat, ChatFilter> request,
    required this.currentUser,
  }) : super(
    request: request,
  );

  @override
  State<AbstractObjectTile> createState() => ChatTileState();
}

class ChatTileState extends AbstractObjectTileState<int, Chat, ChatFilter> {
  @override
  Widget build(BuildContext context) {
    final chat = widget.object;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: chat.unreadByMeCount > 0 ? AppStyle.unreadColor : null,
            ),
            child: Row(
              children: [
                _getChatAvatarWidget(chat),
                SmallPadding(),
                Expanded(
                  child: _getNameAndPreviewWidgetIfCan(chat),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color(0x60808080),
          ),
        ],
      ),
    );
  }

  Widget _getChatAvatarWidget(Chat chat) {
    switch (chat.otherUsers.length) {
      case 0:
        throw Exception('No other users in this chat.');
      case 1:
        return UserpicWidget(user: chat.otherUsers[0], size: 50);
    }
    throw Exception('Group chats are not supported. This chat has ' + chat.otherUsers.length.toString() + ' other users.');
  }

  Widget _getNameAndPreviewWidgetIfCan(Chat chat) {
    final lastMessage = chat.lastMessage;
    return (lastMessage == null)
        ? _getNameAndNoPreviewWidget(chat)
        : _getNameAndPreviewWidget(chat, lastMessage);
  }

  Widget _getNameAndNoPreviewWidget(Chat chat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getChatNameWidget(chat),
        SmallPadding(),
        Text(''),
      ],
    );
  }

  Widget _getNameAndPreviewWidget(Chat chat, ChatMessage lastMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _getChatNameWidget(chat),
            Spacer(),
            Text(formatTimeOrDate(lastMessage.dateTimeInsert, requireLocale(context))),
          ],
        ),
        SmallPadding(),
        ChatMessagePreviewWidget(
          chat: chat,
          message: lastMessage,
          currentUser: (widget as ChatTile).currentUser,
        ),
      ],
    );
  }

  Widget _getChatNameWidget(Chat chat) {
    switch (chat.otherUsers.length) {
      case 0:
        throw Exception('No other users in this chat.');
      case 1:
        return UserNameWidget(user: chat.otherUsers[0], style: AppStyle.bold);
    }
    throw Exception('Group chats are not supported. This chat has ' + chat.otherUsers.length.toString() + ' other users.');
  }
}
