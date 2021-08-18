import 'package:courseplease/services/net/api_client.dart';

extension TokenSignIn on ApiClient {
  Future<void> tokenSignIn(TokenSignInRequest request) {
    return sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/auth/token-sign-in',
      body: request,
    );
  }
}

class TokenSignInRequest extends RequestBody {
  final int authProviderId;
  final String accessToken;

  TokenSignInRequest({
    required this.authProviderId,
    required this.accessToken,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'authProviderId': authProviderId,
      'accessToken': accessToken,
    };
  }
}
