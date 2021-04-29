import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
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
    return ListTile(
      title: Flex(
        direction: Axis.horizontal,
        children: [
          UserpicAndNameWidget(user: widget.object.author),
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
          ChatButton(user: widget.object.author),
        ],
      ),
    );
  }
}
