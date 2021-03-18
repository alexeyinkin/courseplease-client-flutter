import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  final StatusIconEnum iconName;
  final Icon? icon;
  final String text;
  final Widget? trailing;

  IconTextWidget({
    required this.iconName,
    this.icon,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      padRight(_getIcon()),
      padRight(Text(text)),
    ];

    if (trailing != null) {
      children.add(trailing!);
    }

    return Row(
      children: children,
    );
  }

  Widget _getIcon() {
    if (icon != null) return icon!;

    switch (iconName) {
      case StatusIconEnum.ok:
        return Icon(Icons.check_circle, color: Color(0xFF00A000), size: 24);
      case StatusIconEnum.error:
        return Icon(Icons.cancel, color: Color(0xFFA00000), size: 24);
      case StatusIconEnum.off:
        return Icon(Icons.cancel, color: Color(0xFF808080), size: 24);
      case StatusIconEnum.sync:
        return Icon(Icons.sync, color: Color(0xFF808080), size: 24);
    }

    throw Exception('Unknown status icon');
  }
}

enum StatusIconEnum {
  ok,
  error,
  off,
  sync,
}
