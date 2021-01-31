import 'package:meta/meta.dart';

class AuthState {
  final AuthStatus status;

  AuthState({
    @required this.status,
  });
}

enum AuthStatus {
  notAuthenticated,
  authenticated,
}
