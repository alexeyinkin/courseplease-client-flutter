import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/material.dart';

import 'builders/text.dart';
import 'dropdown_menu_item_separator.dart';

class AllModelsDropdown<I, O extends WithIdTitle<I>> extends StatelessWidget {
  final I? selectedId;
  final ModelCacheBloc<I, O> modelCacheBloc;
  final ValueChanged<I> onChanged;
  final String? labelText;
  final Widget? hint;
  final List<DropdownMenuItem<I>> trailing;
  final ValueFinalWidgetBuilder<O> itemBuilder;

  AllModelsDropdown({
    required this.selectedId,
    required this.modelCacheBloc,
    required this.onChanged,
    this.labelText,
    this.hint,
    this.trailing = const [],
    this.itemBuilder = buildText,
  }) {
    modelCacheBloc.loadAllIfNot();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<I, O>>(
      stream: modelCacheBloc.outObjectsByIds,
      builder: (context, snapshot) => _buildWithModels(context, snapshot.data ?? {}),
    );
  }

  Widget _buildWithModels(BuildContext context, Map<I, O> objectsByIds) {
    final items = objectsByIds.values
        .map((obj) => DropdownMenuItem<I>(value: obj.id, child: itemBuilder(context, obj)))
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
      onChanged(id);
    }
  }
}
