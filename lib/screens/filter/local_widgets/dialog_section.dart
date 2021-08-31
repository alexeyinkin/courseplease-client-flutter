import 'package:flutter/material.dart';

class DialogSectionWidget extends StatelessWidget {
  final String text;
  final Widget child;
  final Widget? titleTrailing;

  DialogSectionWidget({
    required this.text,
    required this.child,
    this.titleTrailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(),
            titleTrailing ?? Container(),
          ],
        ),
        Container(height: 20),
        Container(
          padding: EdgeInsets.only(left: 30),
          child: child,
        ),
      ],
    );
  }
}
