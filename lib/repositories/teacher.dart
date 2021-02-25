import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class TeacherRepository extends AbstractFilteredRepository<int, Teacher, TeacherFilter> {
  static const _entitiesName = 'gallery/teachers';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Teacher>> loadWithFilter(TeacherFilter filter, String pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Teacher> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Teacher>[];

    for (var obj in mapResult.objects) {
      objects.add(Teacher.fromMap(obj));
    }

    return ListLoadResult<Teacher>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Teacher> loadById(int id) {
    return _client
        .getEntity(_entitiesName, id)
        .then((response) => _denormalizeOne(response.data));
  }

  @override
  Future<List<Teacher>> loadByIds(List<int> ids) {
    throw Exception('Not implemented');
  }

  // Nullable
  Teacher _denormalizeOne(Map<String, dynamic> mapResult) {
    if (mapResult == null) return null;
    return Teacher.fromMap(mapResult);
  }

  @override
  Future<List<Teacher>> loadAll() {
    throw UnimplementedError();
  }
}
