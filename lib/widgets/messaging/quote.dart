import 'package:flutter/material.dart';

class QuoteWidget extends StatelessWidget {
  final Widget child;

  QuoteWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).textTheme.bodyText1!.color!,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: child,
    );
  }
}
