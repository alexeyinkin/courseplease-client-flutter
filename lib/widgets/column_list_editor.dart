import 'package:courseplease/blocs/editors.dart';
import 'package:courseplease/widgets/value_list_editor.dart';
import 'package:flutter/material.dart';

import 'builders/column.dart';

class ColumnListEditorWidget<
  O,
  C extends AbstractValueEditorController<O>
> extends StatelessWidget {
  final AbstractValueListEditorController<O, C> controller;
  final ValueEditorWidgetBuilder<O, C> valueEditorWidgetBuilder;

  ColumnListEditorWidget({
    required this.controller,
    required this.valueEditorWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListEditorWidget<O, C>(
      controller: controller,
      valueEditorWidgetBuilder: _buildItem,
      containerBuilder: buildColumn,
    );
  }

  Widget _buildItem(BuildContext context, C controller) {
    return Stack(
      key: Key(controller.hashCode.toString()),
      children: [
        valueEditorWidgetBuilder(context, controller),
        Positioned(
          top: 0,
          right: -9,
          child: _buildDeleteButton(controller),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(C controller) {
    return IconButton(
      icon: Icon(Icons.cancel),
      onPressed: () => this.controller.deleteController(controller),
    );
  }
}
