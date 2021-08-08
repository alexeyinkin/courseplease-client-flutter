import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class WithSelectedButton<A> extends StatelessWidget {
  final int selectedCount;
  final String notSelectedPlaceholderText;
  final List<PopupMenuItem<A>> menuItems;
  final ValueChanged<A> onSelected;
  final bool isLoading;

  WithSelectedButton({
    required this.selectedCount,
    required this.notSelectedPlaceholderText,
    required this.menuItems,
    required this.onSelected,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) {
      return Text(notSelectedPlaceholderText);
    }

    final withSelectedText = tr('WithSelectedButton.withNSelected', namedArgs: {'n': selectedCount.toString()});

    return ElevatedButtonWithDropdownMenu<A>(
      child: Text(withSelectedText),
      onSelected: onSelected,
      isLoading: isLoading,
      items: menuItems,
    );
  }
}
