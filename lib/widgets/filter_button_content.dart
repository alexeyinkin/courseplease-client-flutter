import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';
import 'package:flutter/material.dart';

import 'circle_or_capsule.dart';

class FilterButtonContentWidget<F extends AbstractFilter> extends StatelessWidget {
  final F filter;
  final AbstractFilterButtonService<F> filterButtonService;

  FilterButtonContentWidget({
    required this.filter,
    required this.filterButtonService,
  });

  @override
  Widget build(BuildContext context) {
    final info = filterButtonService.getFilterButtonInfo(filter);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.tune),
        ),
        Positioned(
          right: 2,
          top: 0,
          child: _getConstraintCountWidget(context, info),
        ),
      ],
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
}
