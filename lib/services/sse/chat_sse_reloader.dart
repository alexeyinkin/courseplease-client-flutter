import 'package:courseplease/blocs/chats.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class ChatSseReloader extends AbstractSseReloader {
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();

  @override
  void reload() {
    _chatsCubit.refreshChats();
    _chatsCubit.clearChatMessages();
  }
}
