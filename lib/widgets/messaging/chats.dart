import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/widgets/messaging/chat_list.dart';
import 'package:courseplease/widgets/messaging/select_chat_placeholder.dart';
import 'package:flutter/widgets.dart';

import 'chat_message_list.dart';

class ChatsWidget extends StatefulWidget {
  final filter = ChatFilter();

  static const minSplitWidth = 700;

  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  final _chatsCubit = ChatsCubit();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatsCubit.outState,
      initialData: _chatsCubit.initialState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(ChatsCubitState state) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width < ChatsWidget.minSplitWidth
        ? _buildListOnly(state)
        : _buildSplitView(state);
  }

  Widget _buildListOnly(ChatsCubitState state) {
    return _getChatListWidget(state);
  }

  Widget _getChatListWidget(ChatsCubitState state) {
    return ChatListWidget(
      chatsCubit: _chatsCubit,
      filter: widget.filter,
    );
  }

  Widget _buildSplitView(ChatsCubitState state) {
    return Row(
      children: [
        Expanded(child: _getChatListWidget(state)),
        Container(
          width: 1,
          color: Color(0x60808080),
        ),
        Expanded(child: _getMessageListWidget(state)),
      ],
    );
  }

  Widget _getMessageListWidget(ChatsCubitState state) {
    final chat = state.currentChat;

    if (chat == null) {
      return SelectChatPlaceholderWidget();
    }

    return ChatMessageListWidget(
      filter: state.chatMessageFilter,
    );
  }
}
