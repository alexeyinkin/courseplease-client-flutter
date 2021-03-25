import 'dart:convert';

import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:hive/hive.dart';

class ChatMessageQueuePersisterService {
  final Future<Box<String>> _boxFuture = Hive.openBox<String>('chat-message-queue');

  Future<List<SendingChatMessage>> loadAll() async {
    final result = <SendingChatMessage>[];
    final box = await _boxFuture;

    for (final messageJson in box.values) {
      final message = SendingChatMessage.fromMap(jsonDecode(messageJson));
      message.status = SendingChatMessageStatus.failed;
      result.add(message);
    }

    return result;
  }

  Future<int> add(SendingChatMessage message) async {
    final box = await _boxFuture;
    return box.add(jsonEncode(message));
  }

  Future<void> deleteAt(int index) async {
    final box = await _boxFuture;
    return box.deleteAt(index);
  }
}
