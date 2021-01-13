import 'package:charcode/html_entity.dart';
import 'package:flutter/material.dart';

class UserCountWidget extends StatelessWidget {
  final int count;

  UserCountWidget(this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 4),
          child: Icon(Icons.person, color: Colors.grey),
        ),
        Text(count > 0 ? count.toString() : String.fromCharCode($mdash)),
      ],
    );
  }
}
