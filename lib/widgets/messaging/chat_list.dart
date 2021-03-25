import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chat_list.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/object_linear_list_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../pad.dart';
import 'chat_tile.dart';

class ChatListWidget extends StatefulWidget {
  final ChatListCubit chatListCubit;
  final ChatFilter filter;

  ChatListWidget({
    required this.chatListCubit,
    required this.filter,
  });

  @override
  State<ChatListWidget> createState() => ChatListWidgetState();
}

class ChatListWidgetState extends State<ChatListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();
  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithAuthenticationState(
        snapshot.data ?? _authenticationCubit.initialState,
      ),
    );
  }

  Widget _buildWithAuthenticationState(AuthenticationState state) {
    final user = state.data?.user;
    if (user == null) {
      throw Exception('Should only get here if authenticated');
    }

    return StreamBuilder<ChatListCubitState>(
      stream: widget.chatListCubit.outState,
      builder: (context, snapshot) => _buildWithStates(
        user, snapshot.data ?? widget.chatListCubit.initialState,
      ),
    );
  }

  Widget _buildWithStates(
    User user,
    ChatListCubitState chatListCubitState,
  ) {
    return Column(
      children: [
        _getDebugPanel(chatListCubitState),
        Expanded(child: _getListView(user, chatListCubitState)),
        HorizontalLine(),
      ],
    );
  }

  Widget _getListView(
    User user,
    ChatListCubitState chatListCubitState,
  ) {
    return ObjectLinearListView<int, Chat, ChatFilter, ChatRepository, ChatTile>(
      filter: widget.filter,
      tileFactory: (TileCreationRequest<int, Chat, ChatFilter> request) {
        return _createTile(
          request: request,
          currentUser: user,
          chatListCubitState: chatListCubitState,
        );
      },
      onTap: _handleTap,
      scrollDirection: Axis.vertical,
    );
  }

  ChatTile _createTile({
    required TileCreationRequest<int, Chat, ChatFilter> request,
    required User currentUser,
    required ChatListCubitState chatListCubitState,
  }) {
    final isCurrent = (chatListCubitState.currentChat?.id == request.object.id);
    return ChatTile(
      request: request,
      currentUser: currentUser,
      isCurrent: isCurrent,
    );
  }

  void _handleTap(Chat chat, int index) {
    FocusScope.of(context).unfocus();
    widget.chatListCubit.setCurrentChat(chat);
  }

  Widget _getDebugPanel(ChatListCubitState state) {
    return Row(
      children: [
        ElevatedButton(
          child: Icon(Icons.sync),
          onPressed: () => _onRefreshPressed(state),
        ),
      ],
    );
  }

  void _onRefreshPressed(ChatListCubitState state) {
    _chatsCubit.refreshChats();

    if (state.currentChat != null) {
      _chatsCubit.refreshChatMessages(state.currentChat!.id);
    }
  }
}
