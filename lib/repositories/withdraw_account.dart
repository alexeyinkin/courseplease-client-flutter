import 'package:courseplease/models/filters/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

class WithdrawAccountRepository extends AbstractFilteredRepository<int, WithdrawAccount, WithdrawAccountFilter> {
  static const _entitiesName = 'withdraw/accounts';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<WithdrawAccount>> loadWithFilter(WithdrawAccountFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<WithdrawAccount> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    var objects = <WithdrawAccount>[];

    for (var obj in mapResult.objects) {
      objects.add(WithdrawAccount.fromMap(obj));
    }

    return ListLoadResult<WithdrawAccount>(objects, mapResult.nextPageToken);
  }
}
