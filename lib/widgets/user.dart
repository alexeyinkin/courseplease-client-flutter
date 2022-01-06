import 'package:courseplease/models/user.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/teacher/page.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/urls_userpic.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UserpicAndNameWidget extends StatelessWidget{
  final User user;
  final TextStyle? textStyle;

  static const picSize = 30.0;

  UserpicAndNameWidget({
    required this.user,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserpicWidget(user: user, size: picSize),
          SmallPadding(),
          UserNameWidget(user: user, style: textStyle),
        ],
      ),
    );
  }

  void _onTap() {
    GetIt.instance.get<AppState>().pushPage(
      TeacherPage(
        teacherId: user.id,
      ),
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
  final bool showId;

  UserNameWidget({
    required this.user,
    this.style,
    this.showId = false,
  });

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      user.firstName,
      user.lastName,
    ];

    if (showId) parts.add(user.id.toString());

    return Text(
      parts.join(' '),
      style: style,
    );
  }
}
