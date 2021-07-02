import 'package:flutter/widgets.dart';

typedef ValueFinalWidgetBuilder<T> = Widget Function(BuildContext context, T value);
typedef ChildrenBuilder = Widget Function(BuildContext context, List<Widget> children);
