import 'dart:async';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/widgets/auth/sign_in.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignInDialog extends StatefulWidget {
  final VoidCallback onSignedIn;

  SignInDialog({
    required this.onSignedIn,
  });

  static Future<void> show({
    required BuildContext context,
  }) async {
    bool shown = true;

    await showDialog(
      context: context,
      builder: (context) => SignInDialog(
        onSignedIn: () {
          if (shown) {
            shown = false;
            Navigator.of(context).pop();
          }
        },
      ),
    );

    shown = false;
  }

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationSubscription;

  _SignInDialogState() {
    _authenticationSubscription = _authenticationCubit.outState.listen(_onAuthenticationChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StreamBuilder<AuthenticationState>(
        stream: _authenticationCubit.outState,
        builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
      ),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    switch (state.status) {
      case AuthenticationStatus.deviceKey:
        return SignInWidget();
      default:
        return Container(
          width: 100,
          height: 100,
          child: SmallCircularProgressIndicator(),
        );
    }
  }

  void _onAuthenticationChanged(AuthenticationState state) {
    if (state.status == AuthenticationStatus.authenticated) {
      widget.onSignedIn();
    }
  }

  @override
  void dispose() {
    _authenticationSubscription.cancel();
    super.dispose();
  }
}
