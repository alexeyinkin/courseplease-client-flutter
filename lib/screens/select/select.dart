import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/material.dart';

class SelectScreen<T> extends StatelessWidget {
  final List<T> items;
  final ValueChanged<T> onSelected;
  final ValueFinalWidgetBuilder<T> itemBuilder;
  final double width;

  SelectScreen({
    required this.items,
    required this.onSelected,
    required this.itemBuilder,
    this.width = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: width,           // https://stackoverflow.com/a/53410623/11382675
        child: ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final value = items[index];

    return GestureDetector(
      child: ListTile(
        title: itemBuilder(context, value),
      ),
      onTap: () => Navigator.of(context).pop(value),
    );
  }
}
