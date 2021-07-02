import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/widgets.dart';

Widget buildColumn(BuildContext context, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: alternateWidgetListWith(children, SmallPadding()),
  );
}
