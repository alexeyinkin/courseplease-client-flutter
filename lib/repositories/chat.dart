import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class ChatRepository extends AbstractFilteredRepository<int, Chat, ChatFilter> {
  static const _entitiesName = 'chats';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Chat>> loadWithFilter(ChatFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Chat> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Chat>[];

    for (var obj in mapResult.objects) {
      objects.add(Chat.fromMap(obj));
    }

    return ListLoadResult<Chat>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Chat?> loadById(int id) {
    return _client
        .getEntity(_entitiesName, id)
        .then((response) => _denormalizeOneOrNull(response.data));
  }

  Chat? _denormalizeOneOrNull(Map<String, dynamic>? mapResult) {
    if (mapResult == null) return null;
    return Chat.fromMap(mapResult);
  }
}
