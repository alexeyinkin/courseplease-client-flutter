import 'package:courseplease/blocs/editors/price_range.dart';
import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
import 'package:courseplease/models/shop/price_range.dart';
import 'package:courseplease/services/shop/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PriceRangeSlider extends StatelessWidget {
  final PriceRangeEditorController controller;
  final double maxUsd;

  PriceRangeSlider({
    required this.controller,
    required this.maxUsd,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: controller.changes,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    final range = controller.getValue();
    final max = _getMax(range);

    return RangeSlider(
      min: 0,
      max: max,
      values: RangeValues(range.from, range.to ?? max),
      onChanged: (range) => _onChanged(max, range),
      divisions: _getDivisions(max),
    );
  }

  double _getMax(PriceRange range) {
    final converted = GetIt.instance.get<CurrencyConverter>().convert(
      amount: maxUsd,
      from: CurrencyAlpha3Enum.USD,
      to: range.cur,
    );

    return double.parse(converted.toStringAsPrecision(2));
  }

  int _getDivisions(double max) {
    while (max > 100) max /= 10;
    while (max < 10) max *= 10;
    return max.floor();
  }

  void _onChanged(double max, RangeValues range) {
    controller.setFromTo(
      range.start,
      range.end == max ? null : range.end,
    );
  }
}
