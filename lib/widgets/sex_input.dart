import 'package:courseplease/models/enum/sex.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_toggle_buttons.dart';

class SexInputWidget extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  static const _values = [
    SexEnum.male,
    SexEnum.female,
    SexEnum.unknown,
  ];

  SexInputWidget({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppToggleButtons(
      children: _getButtons(),
      isSelected: _getSelected(),
      onPressed: (index) => onChanged(_values[index]),
    );
  }

  List<Widget> _getButtons() {
    final children = <Widget>[];

    for (final one in _values) {
      children.add(
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(tr('common.sex.' + one)),
        ),
      );
    }

    return children;
  }

  List<bool> _getSelected() {
    final effectiveValue = (_values.contains(value)) ? value : SexEnum.unknown;
    final selected = <bool>[];

    for (final one in _values) {
      selected.add(effectiveValue == one);
    }

    return selected;
  }
}
