import 'package:courseplease/models/filters/abstract.dart';

class PriceFilter extends AbstractFilter {
  final String cur;
  final double from;
  final double? to;

  PriceFilter({
    required this.cur,
    this.from = 0,
    this.to
  }) :
      assert(from != 0 || to != null)
  ;

  static PriceFilter? fromValues({
    String? cur,
    required double from,
    double? to,
  }) {
    if (cur == null) return null;
    if (from == 0 && to == null) return null;

    return PriceFilter(cur: cur, from: from, to: to);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cur': cur,
      'from': from,
      'to': to,
    };
  }
}
