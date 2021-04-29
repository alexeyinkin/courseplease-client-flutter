import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/services/chat_message_queue_persister.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessageSendQueueCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _persister = GetIt.instance.get<ChatMessageQueuePersisterService>();
  final _queue = <SendingChatMessage>[];
  _Status _status = _Status.idle;

  final _outStateController = BehaviorSubject<ChatMessageSendQueueState>();
  Stream<ChatMessageSendQueueState> get outState => _outStateController.stream;

  final _outMessageSentController = BehaviorSubject<ChatMessageSentEvent>();
  Stream<ChatMessageSentEvent> get outMessageSent => _outMessageSentController.stream;

  ChatMessageSendQueueCubit() {
    _init();
  }

  void _init() async {
    _queue.addAll(await _persister.loadAll());
    _pushOutput();
  }

  void enqueue(SendingChatMessage message) async {
    await _persister.add(message);
    _queue.add(message);
    _pushOutput();
    _sendNext();
  }

  void retry(SendingChatMessage message) {
    if (!_queue.contains(message)) return;

    switch (message.status) {
      case SendingChatMessageStatus.failed:
        _retry(message);
        return;
      default:
        return;
    }
  }

  void _retry(SendingChatMessage message) {
    message.status = SendingChatMessageStatus.readyToSend;
    _pushOutput();
    _sendNext();
  }

  Future<void> delete(SendingChatMessage message) async {
    if (!_queue.contains(message)) return;

    switch (message.status) {
      case SendingChatMessageStatus.readyToSend:
      case SendingChatMessageStatus.failed:
        return _delete(message);
      default:
        return;
    }
  }

  // For both manual deletion and successful sending.
  Future<void> _delete(SendingChatMessage message) async {
    final index = _queue.indexOf(message);
    await _persister.deleteAt(index);
    _queue.removeAt(index);
    _pushOutput();
  }

  void _pushOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  ChatMessageSendQueueState _createState() {
    return ChatMessageSendQueueState(
      queue: UnmodifiableListView<SendingChatMessage>(_queue),
    );
  }

  void _sendNext() async {
    final message = _pickNextIfIdle();
    if (message == null) return;

    try {
      message.status = SendingChatMessageStatus.sending;
      _status = _Status.sending;

      final response = await _apiClient.sendChatMessage(
        _messageToSendRequest(message),
      );

      message.status = SendingChatMessageStatus.sent;
      _status = _Status.idle;
      _pushMessageSent(message, response);

      await _delete(message);
    } catch (_) {
      _status = _Status.idle;
      _failAllToSameRecipient(message); // To avoid sending out of order.
      _pushOutput();
    }

    _sendNext();
  }

  SendingChatMessage? _pickNextIfIdle() {
    if (_status != _Status.idle) return null;

    try {
      return _queue.firstWhere((message) => message.status == SendingChatMessageStatus.readyToSend);
    } catch (_) {
      return null;
    }
  }

  SendChatMessageRequest _messageToSendRequest(SendingChatMessage message) {
    return SendChatMessageRequest(
      recipientChatId: message.recipientChatId,
      uuid: message.uuid,
      body: message.body,
    );
  }

  void _pushMessageSent(
    SendingChatMessage message,
    SendChatMessageResponse response,
  ) {
    final event = ChatMessageSentEvent(
      response: response,
      request: message,
    );
    _outMessageSentController.sink.add(event);
  }

  void _failAllToSameRecipient(SendingChatMessage targetMessage) {
    for (final message in _queue) {
      if (message.recipientChatId != targetMessage.recipientChatId) continue;
      message.status = SendingChatMessageStatus.failed;
    }
  }

  @override
  void dispose() {
    _outMessageSentController.close();
    _outStateController.close();
  }
}

enum _Status {
  idle,
  sending,
}

class ChatMessageSendQueueState {
  final UnmodifiableListView<SendingChatMessage> queue;

  ChatMessageSendQueueState({
    required this.queue,
  });
}

class ChatMessageSentEvent {
  final SendingChatMessage request;
  final SendChatMessageResponse response;

  ChatMessageSentEvent({
    required this.request,
    required this.response,
  });
}
