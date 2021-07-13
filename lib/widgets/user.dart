import 'package:courseplease/models/user.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/urls_userpic.dart';
import 'package:flutter/material.dart';

class UserpicAndNameWidget extends StatelessWidget{
  final User user;

  static const _picSize = 30.0;

  UserpicAndNameWidget({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserpicWidget(user: user, size: _picSize),
        SmallPadding(),
        UserNameWidget(user: user),
      ],
    );
  }
}

class UserpicWidget extends StatelessWidget {
  final User user;
  final double size;

  UserpicWidget({
    required this.user,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return UrlsUserpicWidget(
      imageUrls: user.userpicUrls,
      size: size,
    );
  }
}

class UserNameWidget extends StatelessWidget {
  final User user;
  final TextStyle? style;

  UserNameWidget({
    required this.user,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      user.firstName + ' ' + user.lastName,
      style: style,
    );
  }
}
