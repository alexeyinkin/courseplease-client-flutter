import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 20),
          child: Column(
            children: [
              _getUserpic(user),
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

  Widget _getUserpic(User user) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: UserpicWidget(
        user: user,
        size: _getAvatarSize(),
      ),
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
      ),
    );
  }
}
