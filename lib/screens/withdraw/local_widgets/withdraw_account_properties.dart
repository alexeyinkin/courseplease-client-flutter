import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class WithdrawAccountPropertiesWidget extends StatelessWidget {
  final WithdrawService service;
  final WithdrawAccount account;

  WithdrawAccountPropertiesWidget({
    required this.service,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];

    for (final property in service.properties) {
      rows.add(
        TableRow(
          children: [
            Text(property.title + ':'),
            SmallPadding(),
            Text(_getPropertyValue(property.intName)),
          ],
        ),
      );
    }

    return Table(
      children: rows,
      columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
    );
  }

  String _getPropertyValue(String intName) {
    switch (intName) {
      case 'number':
        return account.number;
    }
    return account.properties[intName] ?? '';
  }
}
