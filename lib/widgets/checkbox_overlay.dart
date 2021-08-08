import 'package:flutter/material.dart';

class CheckboxOverlay extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  CheckboxOverlay({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Checkbox(
        onChanged: (value) => onChanged(value ?? false), // Null is for tristate only.
        value: value,
        activeColor: Colors.black,
      ),
    );
  }
}
