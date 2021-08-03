import 'package:courseplease/models/filters/withdraw_order.dart';
import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

class WithdrawOrderRepository extends AbstractFilteredRepository<int, WithdrawOrder, WithdrawOrderFilter> {
  static const _entitiesName = 'withdraw/orders';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<WithdrawOrder>> loadWithFilter(WithdrawOrderFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<WithdrawOrder> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <WithdrawOrder>[];

    for (var obj in mapResult.objects) {
      objects.add(WithdrawOrder.fromMap(obj));
    }

    return ListLoadResult<WithdrawOrder>(objects, mapResult.nextPageToken);
  }
}
