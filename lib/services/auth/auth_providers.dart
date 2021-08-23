import 'package:courseplease/services/auth/google_native_auth_provider.dart';

import 'auth_provider.dart';
import 'facebook_native_auth_provider.dart';
import 'instagram_auth_provider.dart';
import 'oauth_auth_provider.dart';

class AuthProviders {
  static final _facebook  = FacebookNativeAuthProvider(id: 29);
  static final _instagram = InstagramAuthProvider(id: 24, appId: '314996693237774', redirectHostAndPort: OAuthAuthProvider.defaultProductionHostAndPort);
  static final _google    = GoogleNativeAuthProvider(id: 30);

  static final signUpProviders = <AuthProvider>[
    _facebook,
    _google,
  ];

  static final connectProviders = <AuthProvider>[
    _facebook,
    _instagram,
    _google,
  ];
}
