import 'package:courseplease/theme/theme.dart';
import 'package:flutter/widgets.dart';

class SmallPadding extends StatelessWidget {
  const SmallPadding();

  @override
  Widget build(BuildContext context) {
    return Container(width: 10, height: 10);
  }
}

class DotPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 15,
      child: Text('·'),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppStyle.borderColor,
    );
  }
}

class VerticalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppStyle.borderColor,
    );
  }
}

Widget padRight(Widget child) {
  return Container(
    padding: EdgeInsets.only(right: 10),
    child: child,
  );
}

Widget padLeft(Widget child) {
  return Container(
    padding: EdgeInsets.only(left: 10),
    child: child,
  );
}

List<Widget> alternateWidgetListWith(List<Widget> widgets, Widget glue) {
  final result = <Widget>[];
  if (widgets.isEmpty) return result;

  for (final widget in widgets) {
    result.add(widget);
    result.add(glue);
  }

  result.removeLast();
  return result;
}
