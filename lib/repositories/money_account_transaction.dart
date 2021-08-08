import 'package:courseplease/models/filters/money_account_transaction.dart';
import 'package:courseplease/models/shop/money_account_transaction.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'abstract.dart';

class MoneyAccountTransactionRepository extends AbstractFilteredRepository<int, MoneyAccountTransaction, MoneyAccountTransactionFilter> {
  static const _entitiesName = 'me/money-transactions';
  final _client = GetIt.instance.get<ApiClient>();

  @override
  Future<ListLoadResult<MoneyAccountTransaction>> loadWithFilter(MoneyAccountTransactionFilter filter, String? pageToken) {
    return _client
        .getEntities(name: _entitiesName, filter: filter, pageToken: pageToken)
        .then((response) => _denormalizeList(response.data));
  }

  ListLoadResult<MoneyAccountTransaction> _denormalizeList(ListLoadResult<Map<String, dynamic>> mapResult) {
    final objects = <MoneyAccountTransaction>[];

    for (final obj in mapResult.objects) {
      objects.add(MoneyAccountTransaction.fromMap(obj));
    }

    return ListLoadResult<MoneyAccountTransaction>(objects, mapResult.nextPageToken);
  }
}
