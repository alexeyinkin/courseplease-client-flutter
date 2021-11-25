import 'package:flutter/material.dart';

@Deprecated('Use from model_editors package')
class CapsuleWidget extends StatelessWidget {
  final Widget child;
  final bool selected;

  static const verticalPadding = 5.0;
  static const horizontalPadding = 10.0;

  static const _padding = EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding);

  CapsuleWidget({
    required this.child,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: _padding,
        child: child,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    // TODO: Move to theme.
    switch (themeData.brightness) {
      case Brightness.dark:
        return Color(selected ? 0x70FFFFFF : 0x40FFFFFF);
      case Brightness.light:
        return Color(selected ? 0x70000000 : 0x40000000);
    }
  }
}
