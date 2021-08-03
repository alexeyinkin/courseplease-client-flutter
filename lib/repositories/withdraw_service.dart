import 'package:courseplease/models/filters/withdraw_service.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

class WithdrawServiceRepository extends AbstractFilteredRepository<int, WithdrawService, WithdrawServiceFilter> {
  static const _entitiesName = 'withdraw/services';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<WithdrawService>> loadWithFilter(WithdrawServiceFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<WithdrawService> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <WithdrawService>[];

    for (var obj in mapResult.objects) {
      objects.add(WithdrawService.fromMap(obj));
    }

    return ListLoadResult<WithdrawService>(objects, mapResult.nextPageToken);
  }
}
