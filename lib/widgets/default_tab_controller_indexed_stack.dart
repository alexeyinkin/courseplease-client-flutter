import 'package:flutter/material.dart';

class DefaultTabControllerIndexedStack extends StatelessWidget {
  final List<Widget> children;

  DefaultTabControllerIndexedStack({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final controller = DefaultTabController.of(context);

    if (controller == null) {
      throw Exception('DefaultTabController not found in the widget tree.');
    }

    return children[controller.index];
  }
}
