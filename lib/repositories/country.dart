import 'package:courseplease/models/geo/country.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/sort.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

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

    objects.sort(Sorters.titleAsc);
    return objects;
  }

  @override
  Future<Country?> loadById(String id) {
    return loadAll().then((objects) => whereId(objects, id));
  }

  @override
  Future<List<Country>> loadByIds(List<String> ids) {
    return loadAll().then((objects) => whereIds(objects, ids));
  }
}
