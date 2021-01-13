import 'package:flutter/material.dart';

class MessagesTab extends StatefulWidget {// implements TitleWidgetProvider {
  @override
  State<MessagesTab> createState() => MessagesTabState();

  // @override
  // Widget? getTitleWidget() {
  //   return null;
  // }
}

class MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the Messages tab.',
        style: TextStyle(fontSize: 36),
      ),
    );
  }
}
