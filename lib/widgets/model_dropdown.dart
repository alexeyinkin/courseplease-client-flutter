import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

class ModelDropdown<I, O extends WithIdTitle<I>> extends StatefulWidget {
  final I selectedId;
  final List<I> showIds;
  final ModelListByIdsBloc modelListByIdsBloc;
  final ValueChanged<I> onChanged;
  final Widget hint; // Nullable
  final List<DropdownMenuItem> trailing;

  ModelDropdown({
    @required this.selectedId,
    @required this.showIds,
    @required this.modelListByIdsBloc,
    @required this.onChanged,
    this.hint,
    this.trailing = const <DropdownMenuItem>[],
  });

  @override
  State<StatefulWidget> createState() => _ModelDropdownState<I, O>();
}

class _ModelDropdownState<I, O extends WithIdTitle<I>> extends State<ModelDropdown> {
  @override
  Widget build(BuildContext context) {
    widget.modelListByIdsBloc.setCurrentIds(widget.showIds);

    return StreamBuilder(
      stream: widget.modelListByIdsBloc.outState,
      initialData: widget.modelListByIdsBloc.initialState,
      builder: (context, snapshot) => _buildWithModels(snapshot.data.objects),
    );
  }

  Widget _buildWithModels(List<O> objects) {
    final items = objects
        .map((obj) => DropdownMenuItem<I>(value: obj.id, child: Text(obj.title)))
        .toList();

    if (widget.trailing.isNotEmpty) {
      items.add(DropdownMenuItemSeparator<I>());

      for (final item in widget.trailing) {
        items.add(item);
      }
    }

    return DropdownButton<I>(
      value: widget.selectedId,
      items: items,
      onChanged: _handleChange,
      hint: widget.hint,
    );
  }

  void _handleChange(I id) { // Nullable
    if (id != null) {
      widget.onChanged(id);
    }
  }
}

class DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  DropdownMenuItemSeparator() : super(child: Container()); // Trick the assertion.

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 3);
  }
}
