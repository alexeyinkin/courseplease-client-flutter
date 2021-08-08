import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class MyLessonRepository extends AbstractFilteredRepository<int, Lesson, MyLessonFilter> {
  static const _entitiesName = 'me/lessons';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Lesson>> loadWithFilter(MyLessonFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Lesson> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    final objects = <Lesson>[];

    for (var obj in mapResult.objects) {
      objects.add(Lesson.fromMap(obj));
    }

    return ListLoadResult<Lesson>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Lesson?> loadById(int id) {
    return _client
        .getEntity(_entitiesName, id)
        .then((response) => _denormalizeOneOrNull(response.data));
  }

  Lesson? _denormalizeOneOrNull(Map<String, dynamic>? mapResult) {
    if (mapResult == null) return null;
    return Lesson.fromMap(mapResult);
  }
}
