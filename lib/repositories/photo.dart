import 'package:courseplease/models/filters/photo.dart';
import 'package:courseplease/models/photo.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class PhotoRepository extends AbstractFilteredRepository<int, Photo, PhotoFilter> {
  static const _entitiesName = 'photos';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Photo>> loadWithFilter(PhotoFilter filter, String pageToken) {
    return _client
        .getEntities(_entitiesName, filter.toQueryParams(), pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Photo> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Photo>[];

    for (var obj in mapResult.objects) {
      objects.add(Photo.fromMap(obj));
    }

    return ListLoadResult<Photo>(objects, mapResult.nextPageToken);
  }

  @override
  Future<Photo> loadById(int id) {
    throw Exception('Not implemented');
  }

  @override
  Future<List<Photo>> loadByIds(List<int> ids) {
    throw Exception('Not implemented');
  }

  @override
  Future<List<Photo>> loadAll() {
    throw UnimplementedError();
  }
}
