import 'package:courseplease/blocs/editors/checkbox_group.dart';
import 'package:courseplease/widgets/checkbox_and_text.dart';
import 'package:flutter/material.dart';

class CheckboxGroupEditorWidget extends StatelessWidget {
  final CheckboxGroupEditorController controller;
  final List<String> allValues;
  final List<String> labels;

  CheckboxGroupEditorWidget({
    required this.controller,
    required this.allValues,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.changes,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    final children = <Widget>[];

    for (int i = 0; i < allValues.length; i++) {
      final value = allValues[i];

      children.add(
        CheckboxAndTextWidget(
          value: controller.isSelected(value),
          onChanged: (isSelected) => controller.setSelected(value, isSelected ?? false),
          text: labels[i],
        ),
      );
    }

    return Column(
      children: children,
    );
  }
}
