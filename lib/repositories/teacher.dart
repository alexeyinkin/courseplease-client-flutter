import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/teacher.dart';

import 'abstract.dart';

class TeacherRepository extends AbstractFilteredRepository<int, Teacher, TeacherFilter> {
  final _provider = NetworkMapDataProvider();

  @override
  Future<LoadResult<Teacher>> loadWithFilter(TeacherFilter filter, String pageToken) {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/teachers',
      filter.toQueryParams(),
    );

    return _provider.loadList(uri, pageToken).then(_denormalize);
  }

  LoadResult<Teacher> _denormalize(LoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Teacher>[];

    for (var obj in mapResult.objects) {
      objects.add(Teacher.fromMap(obj));
    }

    return LoadResult<Teacher>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Teacher> loadById(int id) {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/teachers/' + id.toString(),
    );
    return _provider.loadSingle(uri.toString()).then(_denormalizeOne);
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
