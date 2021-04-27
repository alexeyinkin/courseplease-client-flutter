import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class DeliveryRepository extends AbstractFilteredRepository<int, Delivery, DeliveryFilter> {
  static const _entitiesName = 'shop/deliveries-as-customer';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<Delivery>> loadWithFilter(DeliveryFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<Delivery> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <Delivery>[];

    for (var obj in mapResult.objects) {
      objects.add(Delivery.fromMap(obj));
    }

    return ListLoadResult<Delivery>(objects, mapResult.nextPageToken);
  }
}
