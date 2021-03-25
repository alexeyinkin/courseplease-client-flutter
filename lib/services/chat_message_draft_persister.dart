import 'dart:convert';

import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:hive/hive.dart';

class ChatMessageDraftPersisterService {
  late final Future<Box> _boxFuture;

  ChatMessageDraftPersisterService() {
    _init();
  }

  void _init() async {
    _boxFuture = Hive.openBox<String>('chat-message-drafts-by-chat-ids');
  }

  Future<SendingChatMessage?> getDraftByChatId(int chatId) async {
    final box = await _boxFuture;
    final messageJson = box.get(chatId);

    if (messageJson == null) return null;

    try {
      return SendingChatMessage.fromMap(jsonDecode(messageJson));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDraft(SendingChatMessage message) async {
    final chatId = message.recipientChatId;

    if (chatId == null) {
      throw Exception('Can only store messages to chats and not to users.');
    }

    final box = await _boxFuture;
    return box.put(chatId, jsonEncode(message));
  }

  Future<void> deleteDraftByChatId(int chatId) async {
    final box = await _boxFuture;
    return box.delete(chatId);
  }
}
