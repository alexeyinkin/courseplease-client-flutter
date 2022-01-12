import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/interfaces/with_id_title_intname_homogenous_children_parent.dart';
import 'package:flutter/material.dart';
import 'package:model_interfaces/model_interfaces.dart';
import '../theme/theme.dart';

class BreadcrumbsWidget<I, O extends WithIdTitleIntNameHomogenousChildrenParent<I, O>> extends StatelessWidget {
  final TreePositionState<I, O> treePositionState;
  final ValueChanged<I?> onChanged;

  BreadcrumbsWidget({
    required this.treePositionState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _buildHome(),
      ..._buildAncestors(),
      ..._buildCurrent(),
      ..._buildDescendants(),
    ];

    return Wrap(
      children: children,
    );
  }

  Widget _buildHome() {
    return GestureDetector(
      child: Icon(Icons.home, size: 40),
      onTap: () => onChanged(null),
    );
  }

  List<Widget> _buildAncestors() {
    final result = <Widget>[];

    for (final item in treePositionState.ancestorBreadcrumbs) {
      result.add(
        _BreadcrumbWidget<I, O>(
          item: item,
          position: _BreadcrumbPosition.ancestor,
          onTap: () => onChanged(item.id),
        ),
      );
    }

    return result;
  }

  List<Widget> _buildCurrent() {
    if (treePositionState.currentObject == null) return [];
    return [
      _BreadcrumbWidget<I, O>(
        item: treePositionState.currentObject!,
        position: _BreadcrumbPosition.current,
      ),
    ];
  }

  List<Widget> _buildDescendants() {
    final result = <Widget>[];

    for (final item in treePositionState.descendantBreadcrumbs) {
      result.add(
        _BreadcrumbWidget<I, O>(
          item: item,
          position: _BreadcrumbPosition.descendant,
          onTap: () => onChanged(item.id),
        ),
      );
    }

    return result;
  }
}

class _BreadcrumbWidget<I, O extends WithIdTitle<I>> extends StatelessWidget {
  final O item;
  final _BreadcrumbPosition position;
  final VoidCallback? onTap;

  _BreadcrumbWidget({
    required this.item,
    required this.position,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildChevron(),
        GestureDetector(
          child: _buildContent(),
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildChevron() {
    switch (position) {
      case _BreadcrumbPosition.ancestor:
      case _BreadcrumbPosition.current:
        return _getRawChevron();

      case _BreadcrumbPosition.descendant:
        return Opacity(
          opacity: .1,
          child: _getRawChevron(),
        );
    }

    throw Exception('Unknown position: ' + position.toString());
  }

  Widget _getRawChevron() {
    return Container(
      child: Icon(
        Icons.chevron_right,
        size: 36,
      ),
    );
  }

  Widget _buildContent() {
    switch (position) {
      case _BreadcrumbPosition.ancestor:
        return Text(
          item.title,
          style: AppStyle.breadcrumbItem,
        );

      case _BreadcrumbPosition.current:
        return Text(
          item.title,
          style: AppStyle.breadcrumbItemActive,
        );

      case _BreadcrumbPosition.descendant:
        return Opacity(
          opacity: .1,
          child: Text(
            item.title,
            style: AppStyle.breadcrumbItem,
          ),
        );
    }

    throw Exception('Unknown position: ' + position.toString());
  }
}

enum _BreadcrumbPosition {
  ancestor,
  current,
  descendant,
}
