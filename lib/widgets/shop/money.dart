import 'package:courseplease/models/money.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

class MoneyWidget extends StatelessWidget {
  final Money money;

  MoneyWidget({
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      money.toString(plusForPositive: true),
      style: _getStyle(),
    );
  }

  TextStyle? _getStyle() {
    if (money.isPositive()) return AppStyle.moneyPositive;
    return money.isNegative()
        ? AppStyle.moneyNegative
        : null;
  }
}
