import 'package:courseplease/blocs/editors.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:courseplease/widgets/builders/wrap.dart';
import 'package:courseplease/widgets/capsule.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/value_list_editor.dart';
import 'package:flutter/material.dart';

class CapsuleListEditorWidget<
  O,
  C extends AbstractValueEditorController<O>
> extends StatelessWidget {
  final AbstractValueListEditorController<O, C> controller;
  final ValueFinalWidgetBuilder<O> capsuleContentBuilder;
  final WidgetBuilder? addButtonBuilder;

  CapsuleListEditorWidget({
    required this.controller,
    required this.capsuleContentBuilder,
    this.addButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListEditorWidget<O, C>(
      controller: controller,
      valueEditorWidgetBuilder: _buildCapsule,
      containerBuilder: _buildWrap,
    );
  }

  Widget _buildWrap(BuildContext context, List<Widget> children) {
    return StreamBuilder<void>(
      stream: controller.changes,
      builder: (context, snapshot) => _buildWrapOnChange(context, children),
    );
  }

  Widget _buildWrapOnChange(BuildContext context, List<Widget> children) {
    if (controller.canAdd && addButtonBuilder != null) {
      children.add(addButtonBuilder!(context));
    }

    return buildWrap(context, children);
  }

  Widget _buildCapsule(BuildContext context, C oneController) {
    return CapsuleWidget(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCapsuleContent(context, oneController),
          SmallPadding(),
          GestureDetector(
            child: Icon(Icons.cancel),
            onTap: () => controller.deleteController(oneController),
          ),
        ],
      ),
    );
  }

  Widget _buildCapsuleContent(BuildContext context, C oneController) {
    final obj = oneController.getValue();
    return (obj == null)
        ? SmallCircularProgressIndicator(scale: .5)
        : capsuleContentBuilder(context, obj);
  }
}
