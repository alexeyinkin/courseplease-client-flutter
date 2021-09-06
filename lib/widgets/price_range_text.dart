import 'package:courseplease/blocs/editors/price_range.dart';
import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/shop/price_range.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class PriceRangeControllerTextWidget extends StatelessWidget {
  final PriceRangeEditorController controller;

  PriceRangeControllerTextWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<void>(
      stream: controller.changes,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return PriceRangeTextWidget(
      priceRange: controller.getValue(),
    );
  }
}

class PriceRangeTextWidget extends StatelessWidget {
  final PriceRange priceRange;

  PriceRangeTextWidget({
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Text(_getText());
  }

  String _getText() {
    if (priceRange.from == 0 && priceRange.to == null) return tr('PriceRangeTextWidget.any');

    final per = tr('util.units.h');

    if (priceRange.to == null) {
      final formatted = Money.singleCurrency(priceRange.cur, priceRange.from).formatPer(per);
      return tr('PriceRangeTextWidget.from', namedArgs: {'from': formatted});
    }

    if (priceRange.from == 0) {
      final formatted = Money.singleCurrency(priceRange.cur, priceRange.to!).formatPer(per);
      return tr('PriceRangeTextWidget.to', namedArgs: {'to': formatted});
    }

    final formattedFrom = formatMoneyValue(priceRange.from);
    final formattedTo = Money.singleCurrency(priceRange.cur, priceRange.to!).formatPer(per);
    return tr('PriceRangeTextWidget.range', namedArgs: {'from': formattedFrom, 'to': formattedTo});
  }
}
