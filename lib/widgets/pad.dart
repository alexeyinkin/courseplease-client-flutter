import 'package:flutter/widgets.dart';

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

  for (final widget in widgets) {
    result.add(widget);
    result.add(glue);
  }

  result.removeLast();
  return result;
}
