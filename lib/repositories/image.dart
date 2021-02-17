import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

abstract class AbstractImageRepository<F extends AbstractFilter> extends AbstractFilteredRepository<int, ImageEntity, F> {
  final _client = GetIt.instance.get<ApiClient>();

  String getEntitiesName();

  @override
  Future<ListLoadResult<ImageEntity>> loadWithFilter(F filter, String pageToken) {
    return _client
        .getEntities(getEntitiesName(), filter, pageToken)
        .then((response) => denormalizeList(response.data));
  }

  @protected
  ListLoadResult<ImageEntity> denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <ImageEntity>[];

    for (var obj in mapResult.objects) {
      objects.add(ImageEntity.fromMap(obj));
    }

    return ListLoadResult<ImageEntity>(objects, mapResult.nextPageToken);
  }

  @override
  Future<ImageEntity> loadById(int id) {
    throw Exception('Not implemented');
  }

  @override
  Future<List<ImageEntity>> loadByIds(List<int> ids) {
    throw Exception('Not implemented');
  }

  @override
  Future<List<ImageEntity>> loadAll() {
    throw UnimplementedError();
  }
}

class GalleryImageRepository extends AbstractImageRepository<ViewImageFilter> {
  static const _entitiesName = 'gallery/images';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }
}

class EditorImageRepository extends AbstractImageRepository<EditImageFilter> {
  static const _entitiesName = 'me/images';

  @override
  String getEntitiesName() {
    return _entitiesName;
  }
}
