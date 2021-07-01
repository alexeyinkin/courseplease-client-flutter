import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/review_delivery_as_customer.dart';
import 'package:courseplease/screens/review_delivery_as_seller/review_delivery_as_seller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../pad.dart';

class RateDeliveryButton extends StatelessWidget {
  final Delivery delivery;
  final DeliveryViewAs viewAs;

  RateDeliveryButton({
    required this.delivery,
    required this.viewAs,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star),
          SmallPadding(),
          Text(tr('RateDeliveryButton.rate')),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    switch (viewAs) {
      case DeliveryViewAs.customer:
        ReviewDeliveryAsCustomerScreen.show(
          context: context,
          delivery: delivery,
          showRate: true,
        );
        break;

      case DeliveryViewAs.seller:
        ReviewDeliveryAsSellerScreen.show(
          context: context,
          delivery: delivery,
          showRate: true,
        );
        break;

      default:
        throw Exception('Unknown delivery viewAs: ' + viewAs.toString());
    }
  }
}
