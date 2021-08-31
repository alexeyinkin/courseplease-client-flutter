import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
import 'package:courseplease/services/shop/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PriceRangeSlider extends StatelessWidget {
  final String cur;
  final double from;
  final double? to;
  final double maxUsd;
  final void Function(double from, double? to) onChanged;

  PriceRangeSlider({
    required this.cur,
    required this.from,
    required this.to,
    required this.maxUsd,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final max = _getMax();

    return RangeSlider(
      min: 0,
      max: max,
      values: RangeValues(from, to ?? max),
      onChanged: _onChanged,
      divisions: _getDivisions(max),
    );
  }

  double _getMax() {
    final converted = GetIt.instance.get<CurrencyConverter>().convert(
      amount: maxUsd,
      from: CurrencyAlpha3Enum.USD,
      to: cur,
    );

    return double.parse(converted.toStringAsPrecision(2));
  }

  int _getDivisions(double max) {
    while (max > 100) max /= 10;
    while (max < 10) max *= 10;
    return max.floor();
  }

  void _onChanged(RangeValues range) {
    final max = _getMax();

    onChanged(
      range.start,
      range.end == max ? null : range.end,
    );
  }
}
