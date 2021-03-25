import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessageSendQueueCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _queue = <SendingChatMessage>[];
  _Status _status = _Status.idle;

  final _outStateController = BehaviorSubject<ChatMessageSendQueueState>();
  Stream<ChatMessageSendQueueState> get outState => _outStateController.stream;

  final _outMessageSentController = BehaviorSubject<ChatMessageSentEvent>();
  Stream<ChatMessageSentEvent> get outMessageSent => _outMessageSentController.stream;

  void enqueue(SendingChatMessage message) {
    _queue.add(message);
    _persist();
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

  void delete(SendingChatMessage message) {
    if (!_queue.contains(message)) return;

    switch (message.status) {
      case SendingChatMessageStatus.readyToSend:
      case SendingChatMessageStatus.failed:
        _delete(message);
        return;
      default:
        return;
    }
  }

  void _delete(SendingChatMessage message) {
    _queue.remove(message);
    _persist();
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

      if (_queue.remove(message)) {
        _persist();
        _pushOutput();
      }
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
      recipientUserId: message.recipientUserId,
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
      if (message.recipientUserId != targetMessage.recipientUserId
          || message.recipientChatId != targetMessage.recipientChatId) {
        continue;
      }
      message.status = SendingChatMessageStatus.failed;
    }
  }

  void _persist() {
    // TODO
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
