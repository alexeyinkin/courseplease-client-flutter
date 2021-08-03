import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/widgets/model_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'builders/abstract.dart';
import 'builders/text.dart';

class FilteredModelsDropdown<
  I,
  O extends WithIdTitle<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends StatelessWidget {
  final I? selectedId;
  final F filter;
  final ValueChanged<O> onModelChanged;
  final String? labelText;
  final Widget? hint;
  final List<DropdownMenuItem<I>> trailing;
  final ValueFinalWidgetBuilder<O> itemBuilder;

  FilteredModelsDropdown({
    required this.selectedId,
    required this.filter,
    required this.onModelChanged,
    this.labelText,
    this.hint,
    this.trailing = const [],
    this.itemBuilder = buildText,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.instance.get<FilteredModelListCache>().getOrCreate<I, O, F, R>(filter);
    bloc.loadAll();

    return StreamBuilder<ModelListState<I, O>>(
      stream: bloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(ModelListState<I, O> state) {
    return ModelDropdown(
      selectedId: selectedId,
      models: state.objects,
      onModelChanged: onModelChanged,
      labelText: labelText,
      hint: hint,
    );
  }
}
