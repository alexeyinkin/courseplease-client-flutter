import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'chat_message_tile.dart';

class SendingChatMessageWidget extends StatelessWidget {
  final SendingChatMessage message;
  final User currentUser;

  SendingChatMessageWidget({
    required this.message,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: ChatMessageTileContent(
        message: message,
        currentUser: currentUser,
      ),
    );
  }

  void _onTap(BuildContext context) async {
    final queueCubit = GetIt.instance.get<ChatMessageSendQueueCubit>();
    final action = await showMenu<_FailedMessageAction>(
      context: context,
      position: getContextRelativeRect(context),
      items: <PopupMenuEntry<_FailedMessageAction>>[
        PopupMenuItem(
          child: Text(tr('SendingChatMessageWidget.retry')),
          value: _FailedMessageAction.retry,
        ),
        PopupMenuItem(
          child: Text(tr('SendingChatMessageWidget.delete')),
          value: _FailedMessageAction.delete,
        ),
      ],
    );

    switch (action) {
      case _FailedMessageAction.retry:
        queueCubit.retry(message);
        break;
      case _FailedMessageAction.delete:
        queueCubit.delete(message);
        break;
      case null:
        break;
    }
  }
}

enum _FailedMessageAction {
  retry,
  delete,
}
