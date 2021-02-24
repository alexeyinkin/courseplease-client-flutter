import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

abstract class ListActionWidget<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  A,
  L extends ListActionCubit<I, A>
> extends StatelessWidget {
  final SelectableListCubit<I, F> selectableListCubit;
  final L listActionCubit; // Nullable

  ListActionWidget({
    @required this.selectableListCubit,
    this.listActionCubit,
  });

  @override
  Widget build(BuildContext context) {
    if (listActionCubit == null) {
      return _buildWithListActionCubitState(null);
    }

    return StreamBuilder(
      stream: listActionCubit.outState,
      initialData: listActionCubit.initialState,
      builder: (context, snapshot) => _buildWithListActionCubitState(snapshot.data),
    );
  }

  Widget _buildWithListActionCubitState(
    ListActionCubitState<A> listActionCubitState, // Nullable
  ) {
    return StreamBuilder(
      stream: selectableListCubit.outState,
      initialData: selectableListCubit.initialState,
      builder: (context, snapshot) => buildWithStates(
        context: context,
        listActionCubitState: listActionCubitState,
        selectableListState: snapshot.data,
      ),
    );
  }

  @protected
  Widget buildWithStates({
    BuildContext context,
    ListActionCubitState<A> listActionCubitState, // Nullable
    SelectableListState<I, F> selectableListState,
  });
}
