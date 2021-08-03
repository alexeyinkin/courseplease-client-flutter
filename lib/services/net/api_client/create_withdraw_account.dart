import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/services/net/api_client.dart';

extension CreateWithdrawAccount on ApiClient {
  Future<WithdrawAccount> createWithdrawAccount(CreateWithdrawAccountRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/withdraw/create-account',
      body: request,
    );
    return WithdrawAccount.fromMap(mapResponse.data);
  }
}

class CreateWithdrawAccountRequest extends RequestBody {
  final String title;
  final int serviceId;
  final Map<String, String> properties;

  CreateWithdrawAccountRequest({
    required this.title,
    required this.serviceId,
    required this.properties,
  });

  Map<String, dynamic> toJson() {
    return {
      'title':      title,
      'serviceId':  serviceId,
      'properties': properties,
    };
  }
}
