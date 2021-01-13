import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

class CapsulesWidget<I, T extends WithIdTitle<I>> extends StatelessWidget {
  final List<WithIdTitle> objects;
  final I selectedId; // Nullable
  final ValueChanged<T> onTap;

  CapsulesWidget({
    @required this.objects,
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

  void _handleTap(WithIdTitle object) {
    if (onTap != null) onTap(object);
  }
}

class _CapsuleWidget extends StatelessWidget {
  final WithIdTitle object;
  final bool selected;
  final VoidCallback onTap; // Nullable

  _CapsuleWidget({
    @required this.object,
    @required this.selected,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            object.title,
          ),
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      onTap: onTap,
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
