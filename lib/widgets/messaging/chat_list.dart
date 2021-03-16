import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/interfaces.dart';
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
    @required this.chatsCubit,
    @required this.filter,
  });

  @override
  State<ChatListWidget> createState() => ChatListWidgetState();
}

class ChatListWidgetState extends State<ChatListWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationCubit.outState,
      initialData: _authenticationCubit.initialState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: ObjectLinearListView<int, Chat, ChatFilter, ChatRepository, ChatTile>(
        filter: widget.filter,
        tileFactory: (TileCreationRequest<int, Chat, ChatFilter> request) {
          return _createTile(
            request: request,
            currentUser: state.data.user,
          );
        },

        // When using Chat as argument type, for some reason an exception is thrown
        // at tile construction in ObjectGird in GridView.builder:
        //
        // type '(Chat, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
        // TODO: Find the reason for the exception, change the argument type to Chat.
        onTap: (WithId chat, int index) {
          if (chat is Chat) {
            _handleTap(chat, index);
          } else {
            throw Exception('A chat is not Chat');
          }
        },

        scrollDirection: Axis.vertical,
      ),
    );
  }

  ChatTile _createTile({
    TileCreationRequest<int, Chat, ChatFilter> request,
    User currentUser,
  }) {
    return ChatTile(
      request: request,
      currentUser: currentUser,
    );
  }

  void _handleTap(Chat chat, int index) {
    widget.chatsCubit.setCurrentChat(chat);
  }
}
