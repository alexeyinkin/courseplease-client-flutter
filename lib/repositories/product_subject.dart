import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

class ProductSubjectRepository extends AbstractRepository<int, ProductSubject> {
  static const _entitiesName = 'gallery/subjects';
  final _client = GetIt.instance.get<ApiClient>();
  Future<List<ProductSubject>>? _allFuture;

  Future<List<ProductSubject>> loadAll() {
    if (_allFuture == null) {
      _allFuture = _client
          .getAllEntities(_entitiesName)
          .then((response) => _denormalize(response.data));

      _allFuture!.then((_) => {_allFuture = null});
    }

    return _allFuture!;
  }

  List<ProductSubject> _denormalize(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <ProductSubject>[];

    for (var obj in mapResult.objects) {
      objects.add(ProductSubject.fromMap(obj));
    }

    return objects;
  }

  @override
  Future<ProductSubject?> loadById(int id) {
    return loadAll().then((objects) => whereId(objects, id));
  }

  @override
  Future<List<ProductSubject>> loadByIds(List<int> ids) {
    return loadAll().then((objects) => whereIds(objects, ids));
  }
}
