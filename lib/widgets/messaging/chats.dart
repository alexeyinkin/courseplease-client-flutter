import 'package:courseplease/blocs/chat_list.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/widgets/messaging/chat_list.dart';
import 'package:courseplease/widgets/messaging/select_chat_placeholder.dart';
import 'package:flutter/widgets.dart';

import '../pad.dart';
import 'chat_message_list.dart';

class ChatsWidget extends StatefulWidget {
  final filter = ChatFilter();

  static const minSplitWidth = 700;

  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  final _chatListCubit = ChatListCubit();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatListCubitState>(
      stream: _chatListCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _chatListCubit.initialState),
    );
  }

  Widget _buildWithState(ChatListCubitState state) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width < ChatsWidget.minSplitWidth
        ? _buildListOnly(state)
        : _buildSplitView(state);
  }

  Widget _buildListOnly(ChatListCubitState state) {
    return _getChatListWidget(state);
  }

  Widget _getChatListWidget(ChatListCubitState state) {
    return ChatListWidget(
      chatListCubit: _chatListCubit,
      filter: widget.filter,
    );
  }

  Widget _buildSplitView(ChatListCubitState state) {
    return Row(
      children: [
        Expanded(child: _getChatListWidget(state)),
        VerticalLine(),
        Expanded(child: _getMessageListWidget(state)),
      ],
    );
  }

  Widget _getMessageListWidget(ChatListCubitState state) {
    final chat = state.currentChat;

    if (chat == null) {
      return SelectChatPlaceholderWidget();
    }

    final filter = state.chatMessageFilter;
    if (filter == null) {
      throw Exception('Filter must be not null if the chat is not null.');
    }

    return ChatMessageListWidget(
      chat: chat,
      filter: filter,
    );
  }
}
