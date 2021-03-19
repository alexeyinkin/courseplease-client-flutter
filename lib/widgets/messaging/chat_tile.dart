import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/chat_avatar.dart';
import 'package:courseplease/widgets/messaging/chat_name.dart';
import 'package:flutter/widgets.dart';

import '../abstract_object_tile.dart';
import '../pad.dart';
import 'chat_message_preview.dart';

class ChatTile extends AbstractObjectTile<int, Chat, ChatFilter> {
  final User currentUser;
  final bool isCurrent;

  ChatTile({
    required TileCreationRequest<int, Chat, ChatFilter> request,
    required this.currentUser,
    required this.isCurrent,
  }) : super(
    request: request,
  );

  @override
  State<AbstractObjectTile> createState() => ChatTileState();
}

class ChatTileState extends AbstractObjectTileState<int, Chat, ChatFilter, ChatTile> {
  @override
  Widget build(BuildContext context) {
    final chat = widget.object;
    late final Color? color;

    if (widget.isCurrent) {
      color = const Color(0x60808080);
    } else if (chat.unreadByMeCount > 0) {
      color = AppStyle.unreadColor;
    } else {
      color = null;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Row(
              children: [
                ChatAvatarWidget(chat: chat, size: 50),
                SmallPadding(),
                Expanded(
                  child: _getNameAndPreviewWidgetIfCan(chat),
                ),
              ],
            ),
          ),
          HorizontalLine(),
        ],
      ),
    );
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
        ChatNameWidget(chat: chat),
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
            ChatNameWidget(chat: chat),
            Spacer(),
            Text(formatTimeOrDate(lastMessage.dateTimeInsert, requireLocale(context))),
          ],
        ),
        SmallPadding(),
        ChatMessagePreviewWidget(
          chat: chat,
          message: lastMessage,
          currentUser: widget.currentUser,
        ),
      ],
    );
  }
}
