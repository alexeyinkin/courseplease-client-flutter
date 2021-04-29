import 'dart:async';
import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/chat_message_send_queue.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessageSendQueueViewCubit extends Bloc {
  final _queueCubit = GetIt.instance.get<ChatMessageSendQueueCubit>();
  late final StreamSubscription _subscription;
  final int chatId;

  String? _checksum;

  final _outStateController = BehaviorSubject<ChatMessageSendQueueState>();
  Stream<ChatMessageSendQueueState> get outState => _outStateController.stream;
  final initialState = ChatMessageSendQueueState(queue: UnmodifiableListView<SendingChatMessage>([]));

  ChatMessageSendQueueViewCubit({
    required this.chatId,
  }) {
    _subscription = _queueCubit.outState.listen(_onQueueStateChange);
  }

  factory ChatMessageSendQueueViewCubit.fromChat(Chat chat) {
    return ChatMessageSendQueueViewCubit(
      chatId: chat.id,
    );
  }

  void _onQueueStateChange(ChatMessageSendQueueState state) {
    final requests = _filterRequests(state);
    final newChecksum = _calculateChecksum(requests);

    if (newChecksum != _checksum) {
      _checksum = newChecksum;
      _outStateController.sink.add(_createState(requests));
    }
  }

  List<SendingChatMessage> _filterRequests(ChatMessageSendQueueState state) {
    final result = <SendingChatMessage>[];

    for (final message in state.queue) {
      if (message.recipientChatId != chatId) {
        continue;
      }
      result.add(message);
    }

    return result;
  }

  String _calculateChecksum(List<SendingChatMessage> messages) {
    final parts = <String>[];

    for (final message in messages) {
      parts.add(message.uuid + '_' + message.status.toString());
    }

    return parts.join('_');
  }

  ChatMessageSendQueueState _createState(List<SendingChatMessage> messages) {
    return ChatMessageSendQueueState(
      queue: UnmodifiableListView<SendingChatMessage>(messages),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _outStateController.close();
  }
}
