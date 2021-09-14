import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'userpic_editor.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final List<Widget> childrenUnderUserpic;
  final List<Widget> childrenUnderName;

  ProfileWidget({
    required this.user,
    this.childrenUnderUserpic = const <Widget>[],
    this.childrenUnderName = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.instance.get<AuthenticationBloc>();
    return StreamBuilder<AuthenticationState>(
      stream: cubit.outState,
      builder: (context, snapshot) => _buildWithAuthenticationState(snapshot.data ?? cubit.initialState),
    );
  }

  Widget _buildWithAuthenticationState(AuthenticationState state) {
    final isMe = state.data?.user?.id == user.id;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 20),
          child: Column(
            children: [
              _getUserpicWithContainer(user, isMe),
              ...childrenUnderUserpic,
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getNameLine(user),
              ...childrenUnderName,
            ],
          ),
        ),
      ],
    );
  }

  Widget _getUserpicWithContainer(User user, bool isMe) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: _getUserpicWidget(user, isMe),
    );
  }

  Widget _getUserpicWidget(User user, bool isMe) {
    if (isMe) {
      return UserpicEditorWidget(
        user: user,
        size: _getAvatarSize(),
      );
    }

    return UserpicWidget(
      user: user,
      size: _getAvatarSize(),
    );
  }

  double _getAvatarSize() {
    return 200; // TODO: Scale with screen.
  }

  Widget _getNameLine(User user) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: UserNameWidget(
        user: user,
        style: AppStyle.pageTitle,
        showId: true,
      ),
    );
  }
}
