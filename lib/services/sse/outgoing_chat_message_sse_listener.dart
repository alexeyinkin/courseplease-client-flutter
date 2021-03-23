import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/sse/abstract.dart';
import 'package:get_it/get_it.dart';

class OutgoingChatMessageSseListener extends AbstractSseListener {
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();

  @override
  void onEvent(ServerSentEvent event) {
    final bodyMap = event.body;

    if (bodyMap == null) return; // Message is deleted at server by the time of fetch.

    final message = ChatMessage.fromMap(bodyMap['message']);
    _chatsCubit.onOutgoingMessage(message);
  }
}
