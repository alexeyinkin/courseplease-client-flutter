import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/review_delivery_as_customer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../pad.dart';

class RateDeliveryButton extends StatelessWidget {
  final Delivery delivery;

  RateDeliveryButton({
    required this.delivery,
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
    ReviewDeliveryAsCustomerScreen.show(
      context: context,
      delivery: delivery,
      showRate: true,
    );
  }
}
