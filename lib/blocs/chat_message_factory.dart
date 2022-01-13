import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'authentication.dart';
import 'chats.dart';

class ChatMessageFactory extends Bloc {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationCubitSubscription;

  final _uuidGenerator = Uuid();
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();

  User? _currentUser;

  ChatMessageFactory() {
    _authenticationCubitSubscription = _authenticationCubit.outState.listen(
      _onAuthenticationChange
    );
  }

  void _onAuthenticationChange(AuthenticationState state) {
    _currentUser = state.data?.user;
  }

  void send({
    required int chatId,
    required int type,
    required MessageBody body,
  }) {
    if (!_isValid()) return;

    _chatsCubit.send(
      SendingChatMessage(
        senderUserId: _currentUser!.id,
        chatId:       chatId,
        type:         type,
        body:         body,
        uuid:         _uuidGenerator.v4(),
        status:       SendingChatMessageStatus.readyToSend,
      ),
    );
  }

  bool _isValid() {
    return _currentUser != null;
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
  }
}
