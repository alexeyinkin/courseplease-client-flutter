import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/sse/abstract.dart';
import 'package:get_it/get_it.dart';

class IncomingChatMessageReadSseListener extends AbstractSseListener {
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();

  @override
  void onEvent(ServerSentEvent event) {
    final bodyMap = event.body;

    if (bodyMap == null) return; // Should never get here, it's always present.

    _chatsCubit.onIncomingMessageRead(
      bodyMap['chatId'],
      bodyMap['messageId'],
    );
  }
}
