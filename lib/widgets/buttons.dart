import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWithProgress extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback onPressed; // Nullable
  final bool enabled;

  ElevatedButtonWithProgress({
    @required this.child,
    @required this.isLoading,
    @required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      child,
    ];

    if (isLoading) {
      children.add(Container(width: 10));
      children.add(SmallCircularProgressIndicator(scale: .5));
    }

    return ElevatedButton(
      child: Row(
        children: children,
        mainAxisSize: MainAxisSize.min,
      ),
      onPressed: (isLoading || !enabled) ? null : onPressed,
    );
  }
}
