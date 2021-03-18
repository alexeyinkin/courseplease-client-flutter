import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/screens/home/local_widgets/my_profile.dart';
import 'package:courseplease/widgets/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<AuthenticationState>(
        stream: _authenticationCubit.outState,
        builder: (context, snapshot) => buildWithState(snapshot.data ?? _authenticationCubit.initialState),
      ),
    );
  }

  Widget buildWithState(AuthenticationState state) {
    switch (state.status) {
      case AuthenticationStatus.authenticated:
        return MyProfileWidget();
      default:
        return _buildSignIn();
    }
  }

  Widget _buildSignIn() {
    return Center(
      child: SignInWidget(
      ),
    );
  }
}
