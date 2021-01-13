import 'package:courseplease/models/filters/photo.dart';
import 'package:courseplease/models/photo.dart';

import 'abstract.dart';

class PhotoRepository extends AbstractFilteredRepository<int, Photo, PhotoFilter> {
  final _provider = NetworkMapDataProvider();

  @override
  Future<LoadResult<Photo>> loadWithFilter(PhotoFilter filter, String pageToken) {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/photos',
      filter.toQueryParams(),
    );

    return _provider.loadList(uri, pageToken).then(_denormalize);
  }

  LoadResult<Photo> _denormalize(LoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Photo>[];

    for (var obj in mapResult.objects) {
      objects.add(Photo.fromMap(obj));
    }

    return LoadResult<Photo>(objects, mapResult.nextPageToken);
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
