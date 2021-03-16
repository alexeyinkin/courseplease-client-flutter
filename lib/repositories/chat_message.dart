import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class ChatMessageRepository extends AbstractFilteredRepository<int, ChatMessage, ChatMessageFilter> {
  static const _entitiesName = 'chatMessages';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<ChatMessage>> loadWithFilter(ChatMessageFilter filter, String pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<ChatMessage> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <ChatMessage>[];

    for (var obj in mapResult.objects) {
      objects.add(ChatMessage.fromMap(obj));
    }

    return ListLoadResult<ChatMessage>(objects, mapResult.nextPageToken);
  }
}
