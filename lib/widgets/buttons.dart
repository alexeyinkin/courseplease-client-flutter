import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWithProgress extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool enabled;

  ElevatedButtonWithProgress({
    required this.child,
    required this.isLoading,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      child,
    ];

    if (isLoading) {
      children.add(Container(width: 10));
      children.add(SmallCircularProgressIndicator(scale: .5));
    }

    return ElevatedButton(
      child: Row(
        children: children,
        mainAxisSize: MainAxisSize.min,
      ),
      onPressed: (isLoading || !enabled) ? null : onPressed,
    );
  }
}

class ElevatedButtonWithDropdownMenu<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final bool isLoading;
  final bool enabled;

  ElevatedButtonWithDropdownMenu({
    required this.child,
    required this.items,
    required this.onSelected,
    required this.isLoading,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWithProgress(
      child: Row(
        children: [
          child,
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
      isLoading: isLoading,
      enabled: enabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    showMenu<T>(
      context: context,
      position: getContextRelativeRect(context),
      items: items,
    ).then(_onSelected);
  }

  void _onSelected(T? result) {
    if (result != null) {
      onSelected(result);
    }
  }
}
