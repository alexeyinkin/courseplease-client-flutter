import 'package:courseplease/models/filters/lesson.dart';
import 'package:courseplease/models/lesson.dart';

import 'abstract.dart';

class LessonRepository extends AbstractFilteredRepository<int, Lesson, LessonFilter> {
  final _provider = NetworkMapDataProvider();

  @override
  Future<LoadResult<Lesson>> loadWithFilter(LessonFilter filter, String pageToken) {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/lessons',
      filter.toQueryParams(),
    );

    return _provider.loadList(uri, pageToken).then(_denormalize);
  }

  LoadResult<Lesson> _denormalize(LoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Lesson>[];

    for (var obj in mapResult.objects) {
      objects.add(Lesson.fromMap(obj));
    }

    return LoadResult<Lesson>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Lesson> loadById(int id) {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/lessons/' + id.toString(),
    );
    return _provider.loadSingle(uri.toString()).then(_denormalizeOne);
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
