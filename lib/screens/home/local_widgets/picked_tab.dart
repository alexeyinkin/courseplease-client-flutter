import 'package:flutter/material.dart';

class PickedTab extends StatefulWidget { //}implements TitleWidgetProvider{
  @override
  State<PickedTab> createState() => PickedTabState();

  // @override
  // Widget? getTitleWidget() {
  //   return null;
  // }
}

class PickedTabState extends State<PickedTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the Picked tab.',
        style: TextStyle(fontSize: 36),
      ),
    );
  }
}
