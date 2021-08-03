import 'package:collection/collection.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

import 'dropdown_menu_item_separator.dart';

class ModelDropdown<I, O extends WithIdTitle<I>> extends StatelessWidget {
  final I? selectedId;
  final List<O> models;
  final ValueChanged<I>? onIdChanged;
  final ValueChanged<O>? onModelChanged;
  final String? labelText;
  final Widget? hint;
  final List<DropdownMenuItem<I>> trailing;

  ModelDropdown({
    required this.selectedId,
    required this.models,
    this.onIdChanged,
    this.onModelChanged,
    this.labelText,
    this.hint,
    List<DropdownMenuItem<I>>? trailing,
  }) :
      trailing = trailing ?? <DropdownMenuItem<I>>[]
  ;

  @override
  Widget build(BuildContext context) {
    final items = models
        .map((obj) => DropdownMenuItem<I>(value: obj.id, child: Text(obj.title)))
        .toList();

    if (trailing.isNotEmpty) {
      items.add(DropdownMenuItemSeparator<I>());

      for (final item in trailing) {
        items.add(item);
      }
    }

    return DropdownButtonFormField<I>(
      value: selectedId,
      items: items,
      onChanged: _handleChange,
      hint: hint,
      decoration: getInputDecoration(context: context, labelText: labelText),
    );
  }

  void _handleChange(I? id) {
    if (id != null) {
      if (onIdChanged != null) onIdChanged!(id);

      if (onModelChanged != null) {
        final model = models.firstWhereOrNull((element) => element.id == id);
        if (model != null) onModelChanged!(model);
      }
    }
  }
}
