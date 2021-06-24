import 'package:courseplease/models/shop/delivery.dart';
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
      onPressed: _onPressed,
      child: Text(tr('DeliveryProblemButton.text')),
    );
  }

  void _onPressed() {

  }
}
