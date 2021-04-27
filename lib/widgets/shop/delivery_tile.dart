import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';

class DeliveryTile extends AbstractObjectTile<int, Delivery, DeliveryFilter> {
  DeliveryTile({
    required TileCreationRequest<int, Delivery, DeliveryFilter> request,
  }) : super(
    request: request,
  );

  @override
  _DeliveryTileState createState() => _DeliveryTileState();
}

class _DeliveryTileState extends AbstractObjectTileState<int, Delivery, DeliveryFilter, DeliveryTile> {
  @override
  Widget build(BuildContext context) {
    return Text('Delivery Tile ' + widget.object.id.toString());
  }
}
