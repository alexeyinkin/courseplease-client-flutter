import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/repositories/delivery.dart';
import 'package:flutter/material.dart';

import '../abstract_object_tile.dart';
import '../object_linear_list_view.dart';
import 'delivery_tile.dart';

class DeliveryListWidget extends StatelessWidget {
  final DeliveryFilter filter;
  final Widget? titleIfNotEmpty;

  DeliveryListWidget({
    required this.filter,
    this.titleIfNotEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectLinearListView<int, Delivery, DeliveryFilter, DeliveryRepository, DeliveryTile>(
      filter: filter,
      tileFactory: _createTile,
      scrollDirection: Axis.vertical,
      titleIfNotEmpty: titleIfNotEmpty,
    );
  }

  DeliveryTile _createTile(
    TileCreationRequest<int, Delivery, DeliveryFilter> request,
  ) {
    return DeliveryTile(
      request: request,
    );
  }
}
