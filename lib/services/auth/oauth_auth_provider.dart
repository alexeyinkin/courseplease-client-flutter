import 'dart:convert';
import 'dart:ui';

import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_oauth_temp_token.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

abstract class OAuthAuthProvider extends AuthProvider {
  final String redirectHostAndPort;

  OAuthAuthProvider({
    required int id,
    required String intName,
    required String title,
    required Color color,
    required this.redirectHostAndPort,
  }) : super(
    id: id,
    intName: intName,
    title: title,
    color: color,
  );

  static const defaultLocalPort = 8585;
  static const defaultLocalHostAndPort = 'localhost:$defaultLocalPort';
  static const defaultLocalUri = 'https://localhost:$defaultLocalPort/';
  static const defaultProductionHostAndPort = 'courseplease.com';

  @override
  Future<void> authenticate(BuildContext context) async {
    final apiClient = GetIt.instance.get<ApiClient>();
    final request = CreateOAuthTempTokenRequest(providerId: id);
    final tempToken = await apiClient.createOAuthTempToken(request);

    final stateAssoc = {
      'key': tempToken.key,
      'host': OAuthAuthProvider.defaultProductionHostAndPort,
    };
    final state = jsonEncode(stateAssoc);

    final uri = getOauthUrl(state);

    await SignInWebViewScreen.show(
      url: uri,
    );
  }

  String getOauthUrl(String state);

  String getRedirectUri() {
    return 'https://' + redirectHostAndPort + '/api/auth/' + id.toString();
  }
}
