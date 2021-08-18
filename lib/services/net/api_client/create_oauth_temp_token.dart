import 'package:courseplease/services/net/api_client.dart';

extension CreateOAuthTempToken on ApiClient {
  Future<CreateOAuthTempTokenResponseData> createOAuthTempToken(CreateOAuthTempTokenRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/auth/createOAuthTempToken',
      body: request,
    );
    return CreateOAuthTempTokenResponseData.fromMap(mapResponse.data);
  }
}

class CreateOAuthTempTokenRequest extends RequestBody {
  final int providerId;

  CreateOAuthTempTokenRequest({
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
    };
  }
}

class CreateOAuthTempTokenResponseData {
  final String key;

  CreateOAuthTempTokenResponseData._({
    required this.key,
  });

  factory CreateOAuthTempTokenResponseData.fromMap(Map<String, dynamic> map) {
    return CreateOAuthTempTokenResponseData._(key: map['key']);
  }
}
