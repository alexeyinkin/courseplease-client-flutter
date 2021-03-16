import 'package:flutter/widgets.dart';

class FittedIconTextWidget extends StatelessWidget {
  final IconData iconData; // Nullable
  final String text; // Nullable

  FittedIconTextWidget({
    this.iconData,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (iconData != null) {
      children.add(Icon(iconData, size: 60));
    }
    if (text != null) {
      children.add(Text(text));
    }

    return Container(
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Opacity(
            opacity: .25,
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
