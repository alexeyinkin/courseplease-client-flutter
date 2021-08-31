import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/screens/filter/filter.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'circle_or_capsule.dart';

class FilterButton<
  F extends AbstractFilter,
  C extends AbstractFilterScreenContentCubit<F>
> extends StatelessWidget {
  final FilterableCubit<F> filterableCubit;
  final AbstractFilterButtonService<F> filterButtonService;
  final ValueGetter<C> dialogContentCubitFactory;
  final ValueFinalWidgetBuilder<C> dialogContentBuilder;

  FilterButton({
    required this.filterableCubit,
    required this.filterButtonService,
    required this.dialogContentCubitFactory,
    required this.dialogContentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FilterableCubitState<F>>(
      stream: filterableCubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? filterableCubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, FilterableCubitState<F> state) {
    final info = filterButtonService.getFilterButtonInfo(state.filter);

    return GestureDetector(
      onTap: () => _onPressed(context, state),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(MdiIcons.filter),
          ),
          Positioned(
            right: 2,
            top: 0,
            child: _getConstraintCountWidget(context, info),
          ),
        ],
      ),
    );
  }

  Widget _getConstraintCountWidget(BuildContext context, FilterButtonInfo info) {
    if (info.constraintCount == 0) return Container();

    final colorScheme = Theme.of(context).colorScheme;

    return CircleOrCapsuleWidget(
      child: Text(
        info.constraintCount.toString(),
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 6,
        ),
      ),
      radius: 6,
      color: colorScheme.primary,
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
