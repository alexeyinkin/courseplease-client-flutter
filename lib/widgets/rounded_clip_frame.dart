import 'package:flutter/material.dart';

class RoundedClipFrameWidget extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  RoundedClipFrameWidget({
    required this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: FittedBox(
        fit: BoxFit.cover,
        child: child,
      ),
    );
  }
}
