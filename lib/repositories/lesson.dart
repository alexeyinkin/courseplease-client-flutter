import 'package:courseplease/models/filters/lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class LessonRepository extends AbstractFilteredRepository<int, Lesson, LessonFilter> {
  static const _entitiesName = 'gallery/lessons';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Lesson>> loadWithFilter(LessonFilter filter, String pageToken) {
    return _client
        .getEntities(_entitiesName, filter.toQueryParams(), pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Lesson> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Lesson>[];

    for (var obj in mapResult.objects) {
      objects.add(Lesson.fromMap(obj));
    }

    return ListLoadResult<Lesson>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Lesson> loadById(int id) {
    return _client
        .getEntity(_entitiesName, id)
        .then((response) => _denormalizeOne(response.data));
  }

  @override
  Future<List<Lesson>> loadByIds(List<int> ids) {
    throw Exception('Not implemented');
  }

  // Nullable
  Lesson _denormalizeOne(Map<String, dynamic> mapResult) {
    if (mapResult == null) return null;
    return Lesson.fromMap(mapResult);
  }

  @override
  Future<List<Lesson>> loadAll() {
    throw UnimplementedError();
  }
}
