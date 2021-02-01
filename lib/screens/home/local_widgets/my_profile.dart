import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/widgets/auth/sign_out_button.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class MyProfileWidget extends StatefulWidget {
  @override
  State<MyProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<MyProfileWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationCubit.outState,
      initialData: _authenticationCubit.initialState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final user = state.user;

    if (user == null) throw Exception('Should not happen.');

    return _buildWithUser(user);
  }

  Widget _buildWithUser(User user) {
    return ProfileWidget(
      user: user,
      childrenUnderUserpic: [
        SignOutButton(),
      ],
      childrenUnderName: [
        _getLocationLine(user),
      ],
    );
  }

  Widget _getLocationLine(User user) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: LocationLineWidget(location: user.location),
    );
  }
}
