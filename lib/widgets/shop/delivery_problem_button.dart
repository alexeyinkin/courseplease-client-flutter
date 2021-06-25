import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/review_delivery_as_customer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DeliveryProblemButton extends StatelessWidget {
  final Delivery delivery;

  DeliveryProblemButton({
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: Text(tr('DeliveryProblemButton.text')),
    );
  }

  void _onPressed(BuildContext context) {
    ReviewDeliveryAsCustomerScreen.show(
      context: context,
      delivery: delivery,
      showRate: false,
    );
  }
}
