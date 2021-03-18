import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/chat_message.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../object_linear_list_view.dart';
import 'chat_message_tile.dart';

class ChatMessageListWidget extends StatefulWidget {
  final ChatMessageFilter filter;

  ChatMessageListWidget({
    required this.filter,
  });

  @override
  _ChatMessageListState createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final user = state.data?.user;
    if (user == null) {
      throw Exception('Should only get here if authenticated');
    }

    return Container(
      child: ObjectLinearListView<int, ChatMessage, ChatMessageFilter, ChatMessageRepository, ChatMessageTile>(
        filter: widget.filter,
        tileFactory: (TileCreationRequest<int, ChatMessage, ChatMessageFilter> request) {
          return _createTile(
            request: request,
            currentUser: user,
          );
        },

        // When using ChatMessage as argument type, for some reason an exception is thrown
        // at tile construction in ObjectGird in GridView.builder:
        //
        // type '(ChatMessage, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
        // TODO: Find the reason for the exception, change the argument type to ChatMessage.
        onTap: (WithId chatMessage, int index) {
          if (chatMessage is ChatMessage) {
            _handleTap(chatMessage, index);
          } else {
            throw Exception('A chatMessage is not ChatMessage');
          }
        },

        scrollDirection: Axis.vertical,
      ),
    );
  }

  ChatMessageTile _createTile({
    required TileCreationRequest<int, ChatMessage, ChatMessageFilter> request,
    required User currentUser,
  }) {
    return ChatMessageTile(
      request: request,
      currentUser: currentUser,
    );
  }

  void _handleTap(ChatMessage chat, int index) {

  }
}
