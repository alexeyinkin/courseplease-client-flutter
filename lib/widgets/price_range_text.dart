import 'package:courseplease/models/money.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class PriceRangeTextWidget extends StatelessWidget {
  final double from;
  final double? to;
  final String cur;

  PriceRangeTextWidget({
    required this.from,
    required this.to,
    required this.cur,
  });

  @override
  Widget build(BuildContext context) {
    return Text(_getText());
  }

  String _getText() {
    if (from == 0 && to == null) return tr('PriceRangeTextWidget.any');

    final per = tr('util.units.h');

    if (to == null) {
      final formatted = Money.singleCurrency(cur, from).formatPer(per);
      return tr('PriceRangeTextWidget.from', namedArgs: {'from': formatted});
    }

    if (from == 0) {
      final formatted = Money.singleCurrency(cur, to!).formatPer(per);
      return tr('PriceRangeTextWidget.to', namedArgs: {'to': formatted});
    }

    final formattedFrom = formatMoneyValue(from);
    final formattedTo = Money.singleCurrency(cur, to!).formatPer(per);
    return tr('PriceRangeTextWidget.range', namedArgs: {'from': formattedFrom, 'to': formattedTo});
  }
}
