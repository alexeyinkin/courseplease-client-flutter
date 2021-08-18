import 'dart:ui';

import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/token_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';

class FacebookNativeAuthProvider extends AuthProvider {
  static const _permissions = ['public_profile', 'email', 'user_location', 'user_birthday', 'user_gender'];

  FacebookNativeAuthProvider({
    required int id,
  }) : super(
    id: id,
    intName: 'facebook',
    title: 'Facebook',
    color: Color(0xFF1877f2),
  );

  @override
  Future<void> authenticate(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: _permissions,
    ); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      final apiClient = GetIt.instance.get<ApiClient>();
      final request = TokenSignInRequest(
        authProviderId: id,
        accessToken: result.accessToken!.token,
      );

      await apiClient.tokenSignIn(request);
    }
  }
}
