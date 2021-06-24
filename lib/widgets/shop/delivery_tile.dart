import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/chat_button.dart';
import 'package:courseplease/widgets/shop/rate_delivery_button.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';
import '../pad.dart';
import '../product_subject.dart';
import 'delivery_problem_button.dart';

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
        children: _getTrailingButtons(),
      ),
    );
  }

  List<Widget> _getTrailingButtons() {
    final result = <Widget>[];

    if (_needRateAsCustomerButton()) {
      result.add(RateDeliveryButton(delivery: widget.object));
      result.add(DeliveryProblemButton(delivery: widget.object));
    } else {
      result.add(ChatButton(user: _getUser()));
    }

    return alternateWidgetListWith(result, SmallPadding());
  }

  bool _needRateAsCustomerButton() {
    if (widget.filter.viewAs != DeliveryViewAs.customer) return false;

    switch (widget.object.status) {
      case DeliveryStatus.agreed:
        if (isInPast(widget.object.dateTimeEnd!)) {
          return true;
        }
        break;
    }

    return false;
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
