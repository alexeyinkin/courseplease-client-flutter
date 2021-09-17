import 'package:courseplease/widgets/toggle_overlay.dart';
import 'package:flutter/material.dart';

class NextImageOverlay extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  NextImageOverlay({
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      bottom: 10,
      child: ToggleOverlay(
        visible: visible,
        child: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
