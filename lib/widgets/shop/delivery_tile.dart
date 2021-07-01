import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/rating.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/shop/review.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/chat_button.dart';
import 'package:courseplease/widgets/single_star_rating.dart';
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
    final user = _getOtherUser();

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
          ..._getDateIfSet(),

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

  List<Widget> _getDateIfSet() {
    final dateTimeStart = widget.object.dateTimeStart;
    if (dateTimeStart == null) return [];

    return [
      Opacity(
        opacity: .5,
        child: DotPadding(),
      ),
      Opacity(
        opacity: .5,
        child: Text(formatDateTime(dateTimeStart, requireLocale(context))),
      ),
    ];
  }

  List<Widget> _getTrailingButtons() {
    final result = <Widget>[];
    var showChat = true;

    final review = _pickMyReview();
    if (review != null) {
      // TODO: Show review text on tap.
      result.add(
        SingleStarRatingWidget(
          rating: Rating.fromDouble(review.rating),
        ),
      );
    }

    if (_needRateAsCustomerButton()) {
      result.add(
        RateDeliveryButton(
          delivery: widget.object,
          viewAs: DeliveryViewAs.customer,
        ),
      );
      result.add(DeliveryProblemButton(delivery: widget.object));
      showChat = false;
    }

    if (_needRateAsSellerButton()) {
      result.add(
        RateDeliveryButton(
          delivery: widget.object,
          viewAs: DeliveryViewAs.seller,
        ),
      );
      showChat = false;
    }

    if (showChat) {
      result.add(ChatButton(user: _getOtherUser()));
    }

    return alternateWidgetListWith(result, SmallPadding());
  }

  Review? _pickMyReview() {
    switch (widget.filter.viewAs) {
      case DeliveryViewAs.customer:
        return widget.object.reviewByCustomer;
      case DeliveryViewAs.seller:
        return widget.object.reviewBySeller;
    }
    throw Exception('Unknown viewAs: ' + widget.filter.viewAs.toString());
  }

  bool _needRateAsCustomerButton() {
    if (widget.filter.viewAs != DeliveryViewAs.customer) return false;
    return widget.object.customerCanReview;
  }

  bool _needRateAsSellerButton() {
    if (widget.filter.viewAs != DeliveryViewAs.seller) return false;
    return widget.object.sellerCanReview;
  }

  User _getOtherUser() {
    switch (widget.filter.viewAs) {
      case DeliveryViewAs.customer:
        return widget.object.seller;
      case DeliveryViewAs.seller:
        return widget.object.customer;
    }
    throw Exception('Unknown viewAs: ' + widget.filter.viewAs.toString());
  }
}
