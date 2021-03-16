import 'package:courseplease/models/user.dart';
import 'package:flutter/material.dart';

class UserpicWidget extends StatelessWidget {
  final User user;
  final double size;

  UserpicWidget({
    @required this.user,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final userpicUrlTail = user.userpicUrls['300x300'] ?? null;

    if (userpicUrlTail == null) {
      return Icon(Icons.person, size: size);
    }

    final userpicUrl = 'https://courseplease.com' + userpicUrlTail;

    return CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(userpicUrl),
    );
  }
}

class UserNameWidget extends StatelessWidget {
  final User user;
  final TextStyle style; // Nullable

  UserNameWidget({
    @required this.user,
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
