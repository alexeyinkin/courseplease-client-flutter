import 'dart:collection';

import 'package:courseplease/blocs/chat_list.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/screens/chat_message_list/chat_message_list.dart';
import 'package:courseplease/widgets/messaging/chat_list.dart';
import 'package:courseplease/widgets/messaging/select_chat_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../pad.dart';
import 'chat_message_list.dart';

class ChatsWidget extends StatefulWidget {
  final filter = ChatFilter();

  static const minSplitWidth = 700;

  @override
  _ChatsWidgetState createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  final _chatListCubit = GetIt.instance.get<ChatsCubit>().chatListCubit;
  final _messageListWidgets = LinkedHashMap<String, Widget>();
  final _chatStack = <Chat>[];

  static const _keepAliveChatCount = 2;

  _ChatsWidgetState() {
    _chatListCubit.outCurrentChat.listen(_onCurrentChatChange);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatListCubitState>(
      stream: _chatListCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _chatListCubit.initialState),
    );
  }

  Widget _buildWithState(ChatListCubitState state) {
    final mode = _getMessageListMode();
    switch (mode) {
      case _MessageListMode.separateScreen:
        return _buildListOnly(state);
      case _MessageListMode.splitView:
        return _buildSplitView(state);
    }
    throw Exception('Unknown _MessageListMode: ' + mode.toString());
  }

  _MessageListMode _getMessageListMode() {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width < ChatsWidget.minSplitWidth
        ? _MessageListMode.separateScreen
        : _MessageListMode.splitView;
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

  // A keep-alive test
  // Widget _getMessageListsTab(ChatListCubitState state) {
  //   final filter = state.chatMessageFilter;
  //   if (filter == null) {
  //     return SelectChatPlaceholderWidget();
  //   }
  //
  //   final key = filter.toString();
  //   if (!_messageListWidgets.containsKey(key)) {
  //     _messageListWidgets[key] = _createMessageListWidget(state);
  //   }
  //
  //   if (_messageListWidgets.length > _keepAliveChatCount) {
  //     _messageListWidgets.remove(_messageListWidgets.keys.first);
  //   }
  //
  //   return DefaultTabController(
  //     length: _messageListWidgets.length,
  //     child: Column(
  //       children: [
  //         TabBar(
  //           tabs: _messageListWidgets.keys.map<Widget>(
  //             (str) {
  //               return Tab(child: Text(str));
  //             },
  //           ).toList(),
  //         ),
  //         Expanded(
  //           child: TabBarView(
  //             children: _messageListWidgets.values.toList(),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _getMessageListWidget(ChatListCubitState state) {
    final filter = state.chatMessageFilter;
    if (filter == null) {
      return SelectChatPlaceholderWidget();
    }

    final ids = WithId.getIds(state.currentChat!.otherUsers);
    final key = filter.toString() + '_' + ids.join('_');

    if (!_messageListWidgets.containsKey(key)) {
      _messageListWidgets[key] = _createMessageListWidget(state);
    }

    if (_messageListWidgets.length > _keepAliveChatCount) {
      _messageListWidgets.remove(_messageListWidgets.keys.first);
    }

    return IndexedStack(
      index: _messageListWidgets.keys.toList().indexOf(key),
      children: _messageListWidgets.values.toList(),
    );
  }

  Widget _createMessageListWidget(ChatListCubitState state) {
    final chat = state.currentChat;
    final filter = state.chatMessageFilter;

    if (chat == null || filter == null) {
      throw Exception('Filter must be not null if the chat is not null.');
    }

    return ChatMessageListWidget(
      chat: chat,
      filter: filter,
      showTitle: true,
    );
  }

  void _onCurrentChatChange(Chat? chat) {
    if (chat == null) return;

    switch (_getMessageListMode()) {
      case _MessageListMode.separateScreen:
        _showMessageListScreen(chat);
        break;
    }

    _removeUserChatFromStack(chat);
  }

  void _showMessageListScreen(Chat chat) async {
    if (_chatStack.isNotEmpty && _chatStack.last.id == chat.id) {
      // Either we attempted to open a chat when it is currently active
      // (not impossible now), or we popped the top chat and the one
      // underneath it is showing. Either way, do nothing.
      return;
    }

    _chatStack.add(chat);
    await ChatMessageListScreen.show(
      context: context,
      chat: chat,
      chatMessageFilter: ChatMessageFilter(chatId: chat.id),
    );

    _chatStack.removeLast();

    final newTopChat = _chatStack.isEmpty ? null : _chatStack.last;
    // This will fire the event, but it will be silenced by the check
    // in the beginning of this method.
    _chatListCubit.setCurrentChat(newTopChat);
  }

  void _removeUserChatFromStack(Chat chat) {
    if (chat.otherUsers.length != 1) {
      return; // Multi-user chat (in future).
    }

    final userId = chat.otherUsers[0].id;

    // TODO: Loop through route stack and remove this user's chat, if any.
    //       Otherwise it would be visible on all phones behind
    //       the the chat screen that uses chatId.
  }
}

enum _MessageListMode {
  separateScreen,
  splitView,
}
