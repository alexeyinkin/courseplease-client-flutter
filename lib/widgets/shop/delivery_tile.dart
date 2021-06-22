import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/chat_button.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';
import '../pad.dart';
import '../product_subject.dart';

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
    final user = _getUser();

    return ListTile(
      title: Flex(
        direction: Axis.horizontal,
        children: [
          UserpicAndNameWidget(user: user),
          Opacity(
            opacity: .5,
            child: DotPadding(),
          ),
          Opacity(
            opacity: .5,
            child: ProductSubjectWidget(id: widget.object.productSubjectId),
          ),
          Opacity(
            opacity: .5,
            child: DotPadding(),
          ),
          Opacity(
            opacity: .5,
            child: Text(widget.object.productVariantFormatWithPrice.title),
          ),

          // TODO: Remove this debug ID:
          Opacity(
            opacity: .5,
            child: DotPadding(),
          ),
          Text(widget.object.id.toString()),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatButton(user: user),
        ],
      ),
    );
  }

  User _getUser() {
    switch (widget.filter.viewAs) {
      case DeliveryViewAs.customer:
        return widget.object.author;
      case DeliveryViewAs.author:
        return widget.object.customer;
    }
    throw Exception('Unknown viewAs: ' + widget.filter.viewAs.toString());
  }
}
