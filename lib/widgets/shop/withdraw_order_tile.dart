import 'package:courseplease/models/filters/withdraw_order.dart';
import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../pad.dart';

class WithdrawOrderTile extends AbstractObjectTile<int, WithdrawOrder, WithdrawOrderFilter> {
  WithdrawOrderTile({
    required TileCreationRequest<int, WithdrawOrder, WithdrawOrderFilter> request,
  }) : super(
    request: request,
  );

  @override
  _WithdrawOrderTileState createState() => _WithdrawOrderTileState();
}

class _WithdrawOrderTileState extends AbstractObjectTileState<int, WithdrawOrder, WithdrawOrderFilter, WithdrawOrderTile> {
  @override
  Widget build(BuildContext context) {
    final order = widget.object;
    final locale = requireLocale(context);

    return Wrap(
      children: [
        Text(order.id.toString()),
        SmallPadding(),
        Text(order.money.toString()),
        SmallPadding(),
        Text(formatDateTime(order.dateTimeInsert.toLocal(), locale)),
        SmallPadding(),
        Text(tr('WithdrawOrderTileWidget.status.' + order.status.toString())),
      ],
    );
  }
}
