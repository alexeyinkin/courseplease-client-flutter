import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/screens/filter/filter.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:courseplease/widgets/filter_button_content.dart';
import 'package:flutter/material.dart';

class FilterButton<
  F extends AbstractFilter,
  C extends AbstractFilterScreenContentCubit<F>
> extends StatelessWidget {
  final FilterableCubit<F> filterableCubit;
  final AbstractFilterButtonService<F> filterButtonService;
  final ValueGetter<C> dialogContentCubitFactory;
  final ValueFinalWidgetBuilder<C> dialogContentBuilder;
  final FilterButtonStyle style;

  FilterButton({
    required this.filterableCubit,
    required this.filterButtonService,
    required this.dialogContentCubitFactory,
    required this.dialogContentBuilder,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FilterableCubitState<F>>(
      stream: filterableCubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? filterableCubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, FilterableCubitState<F> state) {
    switch (style) {
      case FilterButtonStyle.elevated:
        return _buildElevated(context, state);
      case FilterButtonStyle.flat:
        return _buildFlat(context, state);
      default:
        throw Exception('Unknown button style: ' + style.toString());
    }
  }

  Widget _buildElevated(BuildContext context, FilterableCubitState<F> state) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(CircleBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.black), // TODO: Use theme?
      ),
      child: FilterButtonContentWidget(filter: state.filter, filterButtonService: filterButtonService),
      onPressed: () => _onPressed(context, state),
    );
  }

  Widget _buildFlat(BuildContext context, FilterableCubitState<F> state) {
    return GestureDetector(
      onTap: () => _onPressed(context, state),
      child: FilterButtonContentWidget(filter: state.filter, filterButtonService: filterButtonService),
    );
  }

  void _onPressed(BuildContext context, FilterableCubitState<F> state) async {
    final contentCubit = dialogContentCubitFactory();
    contentCubit.setFilter(state.filter);

    final result = await FilterScreen.show(
      context: context,
      contentCubit: contentCubit,
      contentWidget: dialogContentBuilder(context, contentCubit),
    );

    if (result == null) return;
    filterableCubit.setFilter(result.filter as F);
  }
}

enum FilterButtonStyle {
  flat,
  elevated,
}
