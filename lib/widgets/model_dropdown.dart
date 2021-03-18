import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

class ModelDropdown<I, O extends WithIdTitle<I>> extends StatefulWidget {
  final I? selectedId;
  final List<I> showIds;
  final ModelListByIdsBloc<I, O> modelListByIdsBloc;
  final ValueChanged<I> onChanged;
  final Widget? hint;
  final List<DropdownMenuItem<I>> trailing;

  ModelDropdown({
    required this.selectedId,
    required this.showIds,
    required this.modelListByIdsBloc,
    required this.onChanged,
    this.hint,
    List<DropdownMenuItem<I>>? trailing,
  }) :
      trailing = trailing ?? <DropdownMenuItem<I>>[]
  ;

  @override
  State<StatefulWidget> createState() => _ModelDropdownState<I, O>();
}

class _ModelDropdownState<I, O extends WithIdTitle<I>> extends State<ModelDropdown<I, O>> {
  @override
  Widget build(BuildContext context) {
    widget.modelListByIdsBloc.setCurrentIds(widget.showIds);

    return StreamBuilder<ModelListByIdsState<O>>(
      stream: widget.modelListByIdsBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? widget.modelListByIdsBloc.initialState),
    );
  }

  Widget _buildWithState(ModelListByIdsState<O> state) {
    return _buildWithModels(state.objects);
  }

  Widget _buildWithModels(List<O> objects) {
    final items = objects
        .map((obj) => DropdownMenuItem<I>(value: obj.id, child: Text(obj.title)))
        .toList();

    if (widget.trailing.isNotEmpty) {
      items.add(_DropdownMenuItemSeparator<I>());

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

  void _handleChange(I? id) {
    if (id != null) {
      widget.onChanged(id);
    }
  }
}

class _DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  _DropdownMenuItemSeparator() : super(child: Container()); // Trick the assertion.

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 3);
  }
}
