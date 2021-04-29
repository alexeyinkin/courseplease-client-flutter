import 'dart:convert';

import 'package:courseplease/models/messaging/chat_message_draft.dart';
import 'package:hive/hive.dart';

class ChatMessageDraftPersisterService {
  final Future<Box<String>> _chatBoxFuture = Hive.openBox<String>('chat-message-drafts-by-chat-ids');
  final Future<Box<String>> _userBoxFuture = Hive.openBox<String>('chat-message-drafts-by-user-ids');

  Future<ChatMessageDraft?> getDraftByChatId(int chatId) async {
    final box = await _chatBoxFuture;
    final draftJson = box.get(chatId);

    if (draftJson == null) return null;

    try {
      return ChatMessageDraft.fromMap(jsonDecode(draftJson));
    } catch (_) {
      return null;
    }
  }

  Future<ChatMessageDraft?> getDraftByUserId(int userId) async {
    final box = await _userBoxFuture;
    final draftJson = box.get(userId);

    if (draftJson == null) return null;

    try {
      return ChatMessageDraft.fromMap(jsonDecode(draftJson));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDraft(ChatMessageDraft draft) {
    final chatId = draft.recipientChatId;
    final userId = draft.recipientUserId;

    if (chatId != null && userId == null) {
      return saveDraftByChatId(chatId, draft);
    }

    if (chatId == null && userId != null) {
      return saveDraftByUserId(userId, draft);
    }

    throw Exception('Expecting exactly one of chatId and userId to be not null');
  }

  Future<void> saveDraftByChatId(int chatId, ChatMessageDraft draft) async {
    final box = await _chatBoxFuture;
    return box.put(chatId, jsonEncode(draft));
  }

  Future<void> saveDraftByUserId(int userId, ChatMessageDraft draft) async {
    final box = await _userBoxFuture;
    return box.put(userId, jsonEncode(draft));
  }

  Future<void> deleteDraftByChatId(int chatId) async {
    final box = await _chatBoxFuture;
    return box.delete(chatId);
  }

  Future<void> deleteDraftByUserId(int userId) async {
    final box = await _userBoxFuture;
    return box.delete(userId);
  }
}
