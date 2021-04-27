import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

class MoneyAccountsWidget extends StatelessWidget {
  final List<MoneyAccount> accounts;

  MoneyAccountsWidget({
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final account in this.accounts) {
      children.add(
        MoneyAccountWidget(
          account: account,
        ),
      );
    }

    return Column(
      children: children,
    );
  }
}

class MoneyAccountWidget extends StatelessWidget {
  final MoneyAccount account;

  MoneyAccountWidget({
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      account.balance.toString(),
      style: AppStyle.h3,
    );
  }
}