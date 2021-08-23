import 'dart:ui';

import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/token_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_it/get_it.dart';

class GoogleNativeAuthProvider extends AuthProvider {
  static const _email   = 'https://www.googleapis.com/auth/userinfo.email';
  static const _profile = 'https://www.googleapis.com/auth/userinfo.profile';
  static const _openid  = 'openid';

  static const _scopes = [
    _email,
    _profile,
    _openid,
  ];

  GoogleNativeAuthProvider({
    required int id,
  }) : super(
    id: id,
    intName: 'google',
    title: 'Google',
    color: Color(0xFFDB4437),
  );

  @override
  Future<void> authenticate(BuildContext context) async {
    final service = GoogleSignIn(scopes: _scopes);

    final result = await service.signIn();
    final authentication = await result?.authentication;
    final accessToken = authentication?.accessToken;

    if (accessToken == null) return;

    final apiClient = GetIt.instance.get<ApiClient>();
    final request = TokenSignInRequest(
      authProviderId: id,
      accessToken: accessToken,
    );

    await apiClient.tokenSignIn(request);
  }
}
