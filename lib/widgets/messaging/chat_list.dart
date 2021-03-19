import 'package:courseplease/blocs/authentication.dart';
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

import 'chat_tile.dart';

class ChatListWidget extends StatefulWidget {
  final ChatsCubit chatsCubit;
  final ChatFilter filter;

  ChatListWidget({
    required this.chatsCubit,
    required this.filter,
  });

  @override
  State<ChatListWidget> createState() => ChatListWidgetState();
}

class ChatListWidgetState extends State<ChatListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
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

    return StreamBuilder<ChatsCubitState>(
      stream: widget.chatsCubit.outState,
      builder: (context, snapshot) => _buildWithStates(
        user, snapshot.data ?? widget.chatsCubit.initialState,
      ),
    );
  }

  Widget _buildWithStates(
    User user,
    ChatsCubitState chatsCubitState,
  ) {
    return Container(
      child: ObjectLinearListView<int, Chat, ChatFilter, ChatRepository, ChatTile>(
        filter: widget.filter,
        tileFactory: (TileCreationRequest<int, Chat, ChatFilter> request) {
          return _createTile(
            request: request,
            currentUser: user,
            chatsCubitState: chatsCubitState,
          );
        },
        onTap: _handleTap,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  ChatTile _createTile({
    required TileCreationRequest<int, Chat, ChatFilter> request,
    required User currentUser,
    required ChatsCubitState chatsCubitState,
  }) {
    final isCurrent = (chatsCubitState.currentChat?.id == request.object.id);
    return ChatTile(
      request: request,
      currentUser: currentUser,
      isCurrent: isCurrent,
    );
  }

  void _handleTap(Chat chat, int index) {
    widget.chatsCubit.setCurrentChat(chat);
  }
}
