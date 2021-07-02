import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppToggleButtons extends StatelessWidget {
  final List<Widget> children;
  final List<bool> isSelected;
  final ValueChanged<int> onPressed;

  AppToggleButtons({
    required this.children,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1?.color ?? AppStyle.errorColor;

    return ToggleButtons(
      children: children,
      isSelected: isSelected,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(AppStyle.borderRadius),
      selectedColor: textColor,
      fillColor: Color(0x40808080),
    );
  }
}
