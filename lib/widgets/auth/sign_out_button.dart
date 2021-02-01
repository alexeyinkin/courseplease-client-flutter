import 'package:courseplease/blocs/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _signOut,
      child: Text('Sign Out'),
    );
  }

  void _signOut() {
    final authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
    authenticationCubit.signOut();
  }
}
