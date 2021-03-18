import 'dart:ui';
import 'auth_provider.dart';

class VkAuthProvider extends AuthProvider {
  final String appId;

  static const version = '5.126';

  VkAuthProvider({
    required int id,
    required String redirectHostAndPort,
    required this.appId,
  }) : super(
    id: id,
    redirectHostAndPort: redirectHostAndPort,
    intName: 'vk',
    title: 'VK',
    color: Color(0xFF2787F5),
  );

  @override
  String getOauthUrl(String state) {
    final uri = Uri(
      scheme: 'https',
      host:   'oauth.vk.com',
      path:   '/authorize',
      queryParameters: {
        'client_id':      appId,
        'display':        'popup',
        'redirect_uri':   getRedirectUri(),
        'scope':          'email',
        'response_type':  'code',
        'state':          state,
        'v':              version,
      }
    );
    return uri.toString();
  }
}
