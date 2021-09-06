import 'package:courseplease/blocs/editors/abstract.dart';
import 'package:courseplease/models/shop/price_range.dart';

class PriceRangeEditorController extends AbstractValueEditorController<PriceRange> {
  final String cur;
  double _from = 0;
  double? _to;

  PriceRangeEditorController({
    required this.cur,
  });

  @override
  void setValue(PriceRange? value) {
    if (value == null) {
      _setNull();
    } else {
      _setNotNull(value);
    }
  }

  void _setNull() {
    _from = 0;
    _to = null;
    fireChange();
  }

  void _setNotNull(PriceRange value) {
    if (value.cur != cur) throw Exception('Cannot change currency once created.');
    _from = value.from;
    _to = value.to;
    fireChange();
  }

  @override
  PriceRange getValue() {
    return PriceRange(cur: cur, from: _from, to: _to);
  }

  void setFromTo(double from, double? to) {
    _from = from;
    _to = to;
    fireChange();
  }
}
