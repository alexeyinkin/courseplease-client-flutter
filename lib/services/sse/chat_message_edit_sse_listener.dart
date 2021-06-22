import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/messaging/chat_message_denormalizer.dart';
import 'package:courseplease/services/sse/abstract.dart';
import 'package:get_it/get_it.dart';

class ChatMessageEditSseListener extends AbstractSseListener {
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();
  final _chatMessageDenormalizer = GetIt.instance.get<ChatMessageDenormalizer>();

  @override
  void onEvent(ServerSentEvent event) {
    final bodyMap = event.body;

    if (bodyMap == null) return; // Message is deleted at server by the time of fetch.

    final message = _chatMessageDenormalizer.denormalize(bodyMap['message']);
    _chatsCubit.onMessageEdit(message);
  }
}
