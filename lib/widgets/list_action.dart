import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

/// A widget that shows content based on the selection in list.
/// This could be buttons to select or deselect, or selection count display.
abstract class AbstractListSelectionWidget<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> extends StatelessWidget {
  final SelectableListCubit<I, F> selectableListCubit;

  AbstractListSelectionWidget({
    required this.selectableListCubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SelectableListState<I, F>>(
      stream: selectableListCubit.outState,
      builder: (context, snapshot) => buildWithSelectableListState(
        context: context,
        selectableListState: snapshot.data ?? selectableListCubit.initialState,
      ),
    );
  }

  @protected
  Widget buildWithSelectableListState({
    required BuildContext context,
    required SelectableListState<I, F> selectableListState,
  });
}

/// Adds a cubit that takes actions on the list.
abstract class AbstractListActionWidget<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  A,
  L extends ListActionCubit<I, A>
> extends AbstractListSelectionWidget<I, O, F> {
  final L listActionCubit;

  AbstractListActionWidget({
    required SelectableListCubit<I, F> selectableListCubit,
    required this.listActionCubit,
  }) : super(
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithSelectableListState({
    required BuildContext context,
    required SelectableListState<I, F> selectableListState,
  }) {
    return StreamBuilder<ListActionCubitState<A>>(
      stream: listActionCubit.outState,
      builder: (context, snapshot) => buildWithStates(
        context: context,
        listActionCubitState: snapshot.data ?? listActionCubit.initialState,
        selectableListState: selectableListState,
      ),
    );
  }

  @protected
  Widget buildWithStates({
    required BuildContext context,
    required ListActionCubitState<A> listActionCubitState,
    required SelectableListState<I, F> selectableListState,
  });
}
