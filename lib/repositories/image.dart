import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

abstract class AbstractImageRepository<F extends AbstractFilter> extends AbstractFilteredRepository<int, ImageEntity, F> {
  final _client = GetIt.instance.get<ApiClient>();

  String getEntitiesName();

  @override
  Future<ListLoadResult<ImageEntity>> loadWithFilter(F filter, String? pageToken) {
    return _client
        .getEntities(name: getEntitiesName(), filter: filter, pageToken: pageToken)
        .then((response) => denormalizeList(response.data));
  }

  @protected
  ListLoadResult<ImageEntity> denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    final objects = <ImageEntity>[];

    for (final obj in mapResult.objects) {
      objects.add(ImageEntity.fromMap(obj));
    }

    return ListLoadResult<ImageEntity>(objects, mapResult.nextPageToken);
  }
}

class GalleryImageRepository extends AbstractImageRepository<GalleryImageFilter> {
  static const _entitiesName = 'gallery/images';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }

  @override
  Future<ImageEntity?> loadById(int id) {
    return _client
        .getEntity(_entitiesName, id)
        .then((response) => _denormalizeOneOrNull(response.data));
  }

  ImageEntity? _denormalizeOneOrNull(Map<String, dynamic>? mapResult) {
    if (mapResult == null) return null;
    return ImageEntity.fromMap(mapResult);
  }
}

class MyImageRepository extends AbstractImageRepository<MyImageFilter> {
  static const _entitiesName = 'me/images';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }
}
