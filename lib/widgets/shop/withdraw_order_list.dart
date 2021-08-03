import 'package:courseplease/models/filters/withdraw_order.dart';
import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/repositories/withdraw_order.dart';
import 'package:courseplease/widgets/shop/withdraw_order_tile.dart';
import 'package:flutter/material.dart';

import '../abstract_object_tile.dart';
import '../object_linear_list_view.dart';

class WithdrawOrderListWidget extends StatelessWidget {
  final WithdrawOrderFilter filter;
  final Widget? titleIfNotEmpty;

  WithdrawOrderListWidget({
    required this.filter,
    this.titleIfNotEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectLinearListView<int, WithdrawOrder, WithdrawOrderFilter, WithdrawOrderRepository, WithdrawOrderTile>(
      filter: filter,
      tileFactory: _createTile,
      scrollDirection: Axis.vertical,
      titleIfNotEmpty: titleIfNotEmpty,
      //shrinkWrap: true,
    );
  }

  WithdrawOrderTile _createTile(
    TileCreationRequest<int, WithdrawOrder, WithdrawOrderFilter> request,
  ) {
    return WithdrawOrderTile(
      request: request,
    );
  }
}
