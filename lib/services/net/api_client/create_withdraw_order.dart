import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/services/net/api_client.dart';

extension CreateWithdrawOrder on ApiClient {
  Future<WithdrawOrder> createWithdrawOrder(CreateWithdrawOrderRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/withdraw/create-order',
      body: request,
    );
    return WithdrawOrder.fromMap(mapResponse.data);
  }
}

class CreateWithdrawOrderRequest extends RequestBody {
  final int withdrawAccountId;
  final double value;
  final String cur;

  CreateWithdrawOrderRequest({
    required this.withdrawAccountId,
    required this.value,
    required this.cur,
  });

  Map<String, dynamic> toJson() {
    return {
      'withdrawAccountId':  withdrawAccountId,
      'value':              value,
      'cur':                cur,
    };
  }
}
