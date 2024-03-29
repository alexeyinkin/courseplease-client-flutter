import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class CommentRepository extends AbstractFilteredRepository<int, Comment, CommentFilter> {
  static const _entitiesName = 'gallery/comments';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Comment>> loadWithFilter(CommentFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Comment> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Comment>[];

    for (var obj in mapResult.objects) {
      objects.add(Comment.fromMap(obj));
    }

    return ListLoadResult<Comment>(objects, mapResult.nextPageToken);
  }

  Future<Comment?> loadByCatalogAndId(String catalog, int id) async {
    final mapResponse = await _client.sendRequest(
      method: HttpMethod.get,
      path: '/api1/{@lang}/gallery/' + catalog + '/comments/' + id.toString(),
    );
    return _denormalizeOneOrNull(mapResponse.data);
  }

  Comment? _denormalizeOneOrNull(Map<String, dynamic>? mapResult) {
    if (mapResult == null) return null;
    return Comment.fromMap(mapResult);
  }
}
