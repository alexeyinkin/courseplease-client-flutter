import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/screens/sign_in_dialog/sign_in_dialog.dart';
import 'package:get_it/get_it.dart';

import '../../main.dart';

class SignInOrCallService {
  Future<void> callOrSignIn(SignInOrCallEvent event) async {
    final cubit = GetIt.instance.get<AuthenticationBloc>();

    if (cubit.currentState.status == AuthenticationStatus.authenticated) {
      event.callback();
      return;
    }

    await SignInDialog.show(context: navigatorKey.currentContext!);
  }

  Future<void> callOrSignInAndCall(SignInOrCallEvent event) async {
    final cubit = GetIt.instance.get<AuthenticationBloc>();

    if (cubit.currentState.status == AuthenticationStatus.authenticated) {
      event.callback();
      return;
    }

    await SignInDialog.show(context: navigatorKey.currentContext!);

    if (cubit.currentState.status == AuthenticationStatus.authenticated) {
      event.callback();
    }
  }
}

class SignInOrCallEvent {
  final void Function() callback;

  SignInOrCallEvent({
    required this.callback,
  });
}
