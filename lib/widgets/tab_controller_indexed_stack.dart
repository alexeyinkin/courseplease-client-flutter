import 'package:courseplease/widgets/tab_controller_builder.dart';
import 'package:flutter/material.dart';

// Unused
@Deprecated('')
class TabControllerIndexedStack extends StatelessWidget {
  final List<Widget> children;
  final TabController? controller;

  TabControllerIndexedStack({
    required this.children,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabControllerBuilder(
      builder: (context, i) => children[i],
      controller: controller,
    );
  }
}
