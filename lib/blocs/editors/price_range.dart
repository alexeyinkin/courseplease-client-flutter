import 'package:courseplease/models/shop/price_range.dart';
import 'package:flutter/foundation.dart';

class PriceRangeEditorController extends ValueNotifier<PriceRange> {
  final String cur;
  double _from = 0;
  double? _to;

  PriceRangeEditorController({
    required this.cur,
  }) : super(PriceRange(cur: cur));

  @override
  set value(PriceRange? value) {
    if (value == null) {
      _setNull();
    } else {
      _setNotNull(value);
    }
  }

  void _setNull() {
    _from = 0;
    _to = null;
    notifyListeners();
  }

  void _setNotNull(PriceRange value) {
    if (value.cur != cur) throw Exception('Cannot change currency once created.');
    _from = value.from;
    _to = value.to;
    notifyListeners();
  }

  @override
  PriceRange get value {
    return PriceRange(cur: cur, from: _from, to: _to);
  }

  void setFromTo(double from, double? to) {
    _from = from;
    _to = to;
    notifyListeners();
  }
}
