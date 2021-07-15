import 'package:flutter/material.dart';

class ToggleOverlay extends StatelessWidget {
  final Widget child;
  final bool visible;

  static const _animationDuration = Duration(milliseconds: 250);

  ToggleOverlay({
    required this.child,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: _animationDuration,
      child: child,
    );
  }
}
