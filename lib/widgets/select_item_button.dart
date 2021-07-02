import 'package:courseplease/screens/select/select.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/material.dart';

class SelectItemButton<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final ValueFinalWidgetBuilder itemBuilder;
  final IconData iconData;

  SelectItemButton({
    required this.items,
    required this.onSelected,
    required this.itemBuilder,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(iconData),
      onTap: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) async {
    final item = await showDialog<T>(
      context: context,
      builder: (_) => SelectScreen<T>(
        items: items,
        onSelected: onSelected,
        itemBuilder: itemBuilder,
      ),
    );

    if (item != null) {
      onSelected(item);
    }
  }
}
