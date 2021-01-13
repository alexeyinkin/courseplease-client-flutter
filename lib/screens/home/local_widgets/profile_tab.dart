import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => ProfileTabState();

  // @override
  // Widget? getTitleWidget() {
  //   return null;
  // }
}

class ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the Profile tab.',
        style: TextStyle(fontSize: 36),
      ),
    );
  }
}
