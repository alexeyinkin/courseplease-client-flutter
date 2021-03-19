import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class ChatsCubit extends Bloc {
  final _cache = GetIt.instance.get<FilteredModelListCache>();

  void refreshChats() {
    final chatLists = _cache.getModelListsByObjectAndFilterTypes<Chat, ChatFilter>();
    for (final list in chatLists.values) {
      list.clearAndLoadFirstPage();
    }
  }

  void refreshChatMessages(int chatId) {
    final chatMessageLists = _cache.getModelListsByObjectAndFilterTypes<ChatMessage, ChatMessageFilter>();
    final filter = ChatMessageFilter(chatId: chatId);
    final currentChatKey = filter.toString();

    for (final entry in chatMessageLists.entries) {
      if (entry.key == currentChatKey) {
        entry.value.clearAndLoadFirstPage();
      } else {
        entry.value.clear();
      }
    }
  }

  @override
  void dispose() {
  }
}
