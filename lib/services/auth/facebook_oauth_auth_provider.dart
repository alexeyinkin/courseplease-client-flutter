import 'dart:ui';
import 'oauth_auth_provider.dart';

class FacebookOAuthAuthProvider extends OAuthAuthProvider {
  final String appId;

  static const version = '9.0';

  FacebookOAuthAuthProvider({
    required int id,
    required String redirectHostAndPort,
    required this.appId,
  }) : super(
    id: id,
    redirectHostAndPort: redirectHostAndPort,
    intName: 'facebook',
    title: 'Facebook',
    color: Color(0xFF1877f2),
  );

  @override
  String getOauthUrl(String state) {
    final uri = Uri(
        scheme: 'https',
        host:   'www.facebook.com',
        path:   'v$version/dialog/oauth',
        queryParameters: {
          'client_id':      appId,
          'display':        'popup',
          'redirect_uri':   getRedirectUri(),
          'scope':          'public_profile,email,user_location,user_birthday,user_gender',
          'auth_type':      'rerequest',
          'state':          state,
        }
    );
    return uri.toString();
  }
}
