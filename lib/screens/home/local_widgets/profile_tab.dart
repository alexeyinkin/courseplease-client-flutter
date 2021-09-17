import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/screens/home/local_widgets/my_profile.dart';
import 'package:courseplease/widgets/auth/sign_in.dart';
import 'package:courseplease/widgets/device_key.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
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
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    return Column(
      children: [
        Expanded(
          child: _buildContentWithState(state),
        ),
        DeviceKeyWidget(),
      ],
    );
  }

  Widget _buildContentWithState(AuthenticationState state) {
    switch (state.status) {
      case AuthenticationStatus.authenticated:
        return MyProfileWidget();
      case AuthenticationStatus.deviceKey:
        return _buildSignIn();
      default:
        return SmallCircularProgressIndicator();
    }
  }

  Widget _buildSignIn() {
    return Center(
      child: SignInWidget(
      ),
    );
  }
}
