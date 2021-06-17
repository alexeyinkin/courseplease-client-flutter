import 'package:courseplease/models/money.dart';
import 'package:flutter/material.dart';

class PriceButton extends StatelessWidget {
  final Money money;
  final String? per;
  final VoidCallback onPressed;

  PriceButton({
    required this.money,
    this.per,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(money.formatPer(per)),
      onPressed: onPressed,
    );
  }
}
