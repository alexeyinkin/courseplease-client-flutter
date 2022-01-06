import 'package:courseplease/widgets/toggle_overlay.dart';
import 'package:flutter/material.dart';

class CloseImageOverlay extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  CloseImageOverlay({
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: ToggleOverlay(
        visible: visible,
        child: IconButton(
          icon: Icon(Icons.close),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
