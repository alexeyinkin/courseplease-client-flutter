import 'dart:ui';

import 'package:meta/meta.dart';

abstract class AuthProvider {
  final int id;
  final String redirectHostAndPort;
  final String intName;
  final String title;
  final Color color;

  static const defaultLocalPort = 8585;
  static const defaultLocalHostAndPort = 'localhost:$defaultLocalPort';
  static const defaultLocalUri = 'https://localhost:$defaultLocalPort/';
  static const defaultProductionHostAndPort = 'courseplease.com';

  AuthProvider({
    @required this.id,
    @required this.redirectHostAndPort,
    @required this.intName,
    @required this.title,
    @required this.color,
  });

  String getOauthUrl(String state);

  String getRedirectUri() {
    return 'https://' + redirectHostAndPort + '/api/auth/' + id.toString();
  }
}
