import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class CheckboxAndTextWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  CheckboxAndTextWidget({
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        SmallPadding(),
        Text(text),
      ],
    );
  }
}
