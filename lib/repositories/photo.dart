import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/photo.dart';
import 'package:courseplease/models/photo.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

abstract class AbstractPhotoRepository<F extends AbstractFilter> extends AbstractFilteredRepository<int, Photo, F> {
  final _client = GetIt.instance.get<ApiClient>();

  String getEntitiesName();

  @override
  Future<ListLoadResult<Photo>> loadWithFilter(F filter, String pageToken) {
    return _client
        .getEntities(getEntitiesName(), filter.toQueryParams(), pageToken)
        .then((response) => denormalizeList(response.data));
  }

  @protected
  ListLoadResult<Photo> denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
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

class GalleryPhotoRepository extends AbstractPhotoRepository<GalleryPhotoFilter> {
  static const _entitiesName = 'gallery/photos';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }
}

class UnsortedPhotoRepository extends AbstractPhotoRepository<UnsortedPhotoFilter> {
  static const _entitiesName = 'sort/unsorted/photos';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }
}
