import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/widgets/capsule.dart';
import 'package:flutter/material.dart';

class CapsulesWidget<I, T extends WithIdTitle<I>> extends StatelessWidget {
  final List<T> objects;
  final I? selectedId;
  final ValueChanged<T>? onTap;

  CapsulesWidget({
    required this.objects,
    this.selectedId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final object in objects) {
      children.add(
        _CapsuleWidget(
          object:   object,
          selected: selectedId == object.id,
          onTap:    () => _handleTap(object),
        ),
      );
    }

    return Container(
      child: Wrap(
        children: children,
        spacing: 10,
      ),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 0, bottom: 7),
    );
  }

  void _handleTap(T object) {
    if (onTap != null) onTap!(object);
  }
}

class _CapsuleWidget extends StatelessWidget {
  final WithIdTitle object;
  final bool selected;
  final VoidCallback? onTap; // Nullable

  _CapsuleWidget({
    required this.object,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CapsuleWidget(
        child: Text(object.title),
        selected: selected,
      ),
      onTap: onTap,
    );
  }
}
