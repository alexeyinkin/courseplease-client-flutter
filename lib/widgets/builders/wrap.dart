import 'package:flutter/widgets.dart';

Widget buildWrap(BuildContext context, List<Widget> children) {
  return Wrap(
    spacing: 10,
    runSpacing: 10,
    children: children,
  );
}
