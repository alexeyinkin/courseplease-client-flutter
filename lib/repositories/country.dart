import 'package:courseplease/models/geo/country.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

class CountryRepository extends AbstractRepository<String, Country> {
  static const _entitiesName = 'geo/countries';
  final _client = GetIt.instance.get<ApiClient>();
  Future<List<Country>>? _allFuture;

  Future<List<Country>> loadAll() {
    if (_allFuture == null) {
      _allFuture = _client
          .getAllEntities(_entitiesName)
          .then((response) => _denormalizeAndSort(response.data));

      _allFuture!.then((_) => {_allFuture = null});
    }

    return _allFuture!;
  }

  List<Country> _denormalizeAndSort(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Country>[];

    for (var obj in mapResult.objects) {
      objects.add(Country.fromMap(obj));
    }

    objects.sort(WithTitle.compareCaseInsensitive);
    return objects;
  }

  @override
  Future<Country?> loadById(String id) {
    return loadAll().then((objects) => WithId.getById(objects, id));
  }

  @override
  Future<Iterable<Country>> loadByIds(List<String> ids) {
    return loadAll().then((objects) => WithId.getByIds(objects, ids));
  }
}
