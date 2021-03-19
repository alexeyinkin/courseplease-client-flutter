import 'package:flutter/widgets.dart';

class CircleOrCapsuleWidget extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;

  CircleOrCapsuleWidget({
    required this.child,
    required this.color,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/a/48676681/11382675
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: radius * 2,
        minHeight: radius * 2,
        maxHeight: radius * 2,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
