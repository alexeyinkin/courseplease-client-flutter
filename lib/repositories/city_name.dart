import 'package:courseplease/models/filters/city_name.dart';
import 'package:courseplease/models/geo/city_name.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class CityNameRepository extends AbstractFilteredRepository<int, CityName, CityNameFilter> {
  static const _entitiesName = 'geo/city-names';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<CityName>> loadWithFilter(CityNameFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<CityName> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <CityName>[];

    for (var obj in mapResult.objects) {
      objects.add(CityName.fromMap(obj));
    }

    return ListLoadResult<CityName>(objects, mapResult.nextPageToken);
  }
}
