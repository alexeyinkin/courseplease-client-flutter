import 'package:courseplease/models/filters/money_account_transaction.dart';
import 'package:courseplease/models/shop/money_account_transaction.dart';
import 'package:courseplease/repositories/money_account_transaction.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/object_table.dart';
import 'package:courseplease/widgets/shop/money.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class MoneyAccountTransactionTable extends StatelessWidget {
  final MoneyAccountTransactionFilter filter;

  MoneyAccountTransactionTable({
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectTableWidget<
      int,
      MoneyAccountTransaction,
      MoneyAccountTransactionFilter,
      MoneyAccountTransactionRepository
    >(
      filter: filter,
      rowBuilder: _buildRow,
      columnWidths: {
        0: FixedColumnWidth(70),  // id
        1: FixedColumnWidth(100), // type
        2: FixedColumnWidth(100), // amount
        3: FixedColumnWidth(100), // balance after
        4: FixedColumnWidth(200), // datetime
        5: FixedColumnWidth(150), // comment
      },
      header: TableRow(
        children: [
          _getHeader(tr('MoneyAccountTransactionTable.field.id')),
          _getHeader(tr('MoneyAccountTransactionTable.field.type')),
          _getHeader(tr('MoneyAccountTransactionTable.field.money')),
          _getHeader(tr('MoneyAccountTransactionTable.field.balanceAfter')),
          _getHeader(tr('MoneyAccountTransactionTable.field.dateTimeInsert')),
          _getHeader(tr('MoneyAccountTransactionTable.field.description')),
        ],
      ),
    );
  }

  Widget _getHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: AppStyle.overlayColor,
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppStyle.tableHeader,
      ),
    );
  }

  TableRow _buildRow(BuildContext context, MoneyAccountTransaction transaction, int index) {
    final locale = requireLocale(context);

    return TableRow(
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: Text(transaction.id.toString()),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(tr('MoneyAccountTransaction.type.' + transaction.type)),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: MoneyWidget(money: transaction.money),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: Text(transaction.money.plus(transaction.balanceBefore).toString()),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(10),
          child: Text(formatDateTime(transaction.dateTimeInsert, locale)),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(transaction.description),
        ),
      ],
    );
  }
}
