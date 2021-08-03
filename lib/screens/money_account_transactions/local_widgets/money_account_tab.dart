import 'package:courseplease/models/filters/money_account_transaction.dart';
import 'package:courseplease/models/filters/withdraw_order.dart';
import 'package:courseplease/models/shop/enum/withdraw_order_status.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/screens/withdraw/withdraw.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/shop/withdraw_order_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'money_account_transaction_table.dart';

class MoneyAccountTabWidget extends StatelessWidget {
  final MoneyAccount account;

  MoneyAccountTabWidget({
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getBalanceWidget(context),
        Container(
          height: 100, // TODO: shrinkWrap the list.
          padding: EdgeInsets.all(10),
          child: _getWithdrawOrdersList(),
        ),
        Expanded(child: _getTransactionsList()),
      ]
    );
  }

  Widget _getBalanceWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            account.balance.toString(),
            style: AppStyle.h3,
          ),
          SmallPadding(),
          _getWithdrawButtonIfNeed(context),
        ],
      ),
    );
  }

  Widget _getWithdrawButtonIfNeed(BuildContext context) {
    if (account.balance.isZero()) return Container();

    return ElevatedButton(
      onPressed: () => _onWithdrawPressed(context),
      child: Text(tr('MoneyAccountTabWidget.withdraw')),
    );
  }

  Widget _getWithdrawOrdersList() {
    final filter = WithdrawOrderFilter(
      status: WithdrawOrderStatusEnum.created,
    );

    return WithdrawOrderListWidget(
      filter:           filter,
      titleIfNotEmpty:  Text(tr('MoneyAccountTabWidget.pendingWithdrawOrders')),
    );
  }

  Widget _getTransactionsList() {
    final filter = MoneyAccountTransactionFilter(
      cur: account.cur,
    );

    return MoneyAccountTransactionTable(
      filter: filter,
    );
  }

  void _onWithdrawPressed(BuildContext context) {
    WithdrawScreen.show(
      context: context,
      account: account,
    );
  }
}
