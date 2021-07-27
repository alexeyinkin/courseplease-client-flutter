import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/screens/money_account_transactions/money_account_transactions.dart';
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
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Text(
        account.balance.toString(),
        style: AppStyle.h3,
      ),
    );
  }

  void _onTap(BuildContext context) {
    MoneyAccountTransactionsScreen.show(
      context: context,
      cur: account.cur,
    );
  }
}
