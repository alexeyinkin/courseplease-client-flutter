import 'package:courseplease/models/money.dart';
import 'package:flutter/material.dart';

class PriceButton extends StatelessWidget {
  final Money money;
  final String per; // Nullable

  PriceButton({
    @required this.money,
    this.per,
  });

  @override
  Widget build(BuildContext context) {
    String title = money.toString();
    if (per != null) title += ' / ' + per;

    return ElevatedButton(
      child: Text(title),
      onPressed: (){},
    );
  }
}
