import 'package:courseplease/blocs/editors/abstract.dart';
import 'package:courseplease/blocs/editors/abstract_list.dart';
import 'package:flutter/material.dart';

import 'builders/abstract.dart';

typedef ValueEditorWidgetBuilder<O, C extends AbstractValueEditorController<O>> = Widget Function(BuildContext context, C controller);

class ValueListEditorWidget<
  O,
  C extends AbstractValueEditorController<O>
> extends StatelessWidget {
  final AbstractValueListEditorController<O, C> controller;
  final ValueEditorWidgetBuilder<O, C> valueEditorWidgetBuilder;
  final ChildrenBuilder containerBuilder;

  ValueListEditorWidget({
    required this.controller,
    required this.valueEditorWidgetBuilder,
    required this.containerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: controller.changes,
      builder: (context, snapshot) => _buildOnChange(context),
    );
  }

  Widget _buildOnChange(BuildContext context) {
    final children = <Widget>[];

    for (final controller in controller.controllers) {
      children.add(valueEditorWidgetBuilder(context, controller));
    }

    return containerBuilder(context, children);
  }
}


class ControllerAddButton extends StatefulWidget {
  final AbstractValueListEditorController controller;

  ControllerAddButton({
    required this.controller,
  });

  @override
  _ControllerAddButtonState createState() => _ControllerAddButtonState();
}

class _ControllerAddButtonState extends State<ControllerAddButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.controller.canAdd,
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () => widget.controller.add(null),
      ),
    );
  }
}
