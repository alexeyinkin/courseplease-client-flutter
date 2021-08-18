import 'dart:ui';
import 'oauth_auth_provider.dart';

class InstagramAuthProvider extends OAuthAuthProvider {
  final String appId;

  InstagramAuthProvider({
    required int id,
    required String redirectHostAndPort,
    required this.appId,
  }) : super(
    id: id,
    redirectHostAndPort: redirectHostAndPort,
    intName: 'instagram',
    title: 'Instagram',
    color: Color(0xFFB83291),
  );

  @override
  String getOauthUrl(String state) {
    final uri = Uri(
      scheme: 'https',
      host:   'api.instagram.com',
      path:   '/oauth/authorize',
      queryParameters: {
        'client_id':      appId,
        'redirect_uri':   getRedirectUri(),
        'scope':          'user_profile,user_media',
        'response_type':  'code',
        'state':          state,
      }
    );
    return uri.toString();
    //return 'https://api.instagram.com/oauth/authorize?client_id=314996693237774&redirect_uri=https://courseplease.com/auth&scope=user_profile,user_media&response_type=code';
  }
}
