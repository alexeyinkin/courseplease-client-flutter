import 'package:courseplease/models/shop/line_item.dart';
import 'package:flutter/widgets.dart';

import 'line_item.dart';

class LineItemsWidget extends StatelessWidget {
  final List<LineItem> lineItems;
  final bool showPrice;

  LineItemsWidget({
    required this.lineItems,
    required this.showPrice,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final lineItem in lineItems) {
      children.add(
        LineItemWidget(
          lineItem: lineItem,
          showPrice: showPrice,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
