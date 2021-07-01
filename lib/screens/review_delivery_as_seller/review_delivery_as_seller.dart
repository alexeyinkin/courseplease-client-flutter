import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/screens/review_delivery/review_delivery.dart';
import 'package:courseplease/screens/review_delivery_as_seller/local_blocs/review_delivery_as_seller.dart';
import 'package:courseplease/screens/review_delivery_as_seller/local_widgets/complaint_form.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReviewDeliveryAsSellerScreen extends StatefulWidget {
  final Delivery delivery;
  final bool showRate;

  ReviewDeliveryAsSellerScreen({
    required this.delivery,
    required this.showRate,
  });

  static Future<DialogResult?> show({
    required BuildContext context,
    required Delivery delivery,
    required bool showRate,
  }) async {
    return showDialog<DialogResult>(
      context: context,
      builder: (context) => ReviewDeliveryAsSellerScreen(
        delivery: delivery,
        showRate: showRate,
      ),
    );
  }

  @override
  _ReviewDeliveryAsSellerScreenState createState() => _ReviewDeliveryAsSellerScreenState(
    delivery: delivery,
    showRate: showRate,
  );
}

class _ReviewDeliveryAsSellerScreenState extends State<ReviewDeliveryAsSellerScreen> {
  final ReviewDeliveryAsSellerScreenCubit _cubit;

  _ReviewDeliveryAsSellerScreenState({
    required Delivery delivery,
    required bool showRate,
  }) :
      _cubit = ReviewDeliveryAsSellerScreenCubit(
        deliveryId: delivery.id,
        showRate: showRate,
      )
  {
    _cubit.outResult.listen(_onCubitResult);
  }

  void _onCubitResult(DialogResult result) {
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReviewDeliveryScreenCubitState>(
      stream: _cubit.outState,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? _cubit.initialState,
      ),
    );
  }

  Widget _buildWithState(ReviewDeliveryScreenCubitState state) {
    return ReviewDeliveryScreen(
      cubit: _cubit,
      delivery: widget.delivery,
      showRate: widget.showRate,
      title: _buildTitle(),
      complaintForm: ComplaintFormAsSellerWidget(
        cubit: _cubit,
        delivery: widget.delivery,
        state: state,
      ),
      otherUser: widget.delivery.customer,
    );
  }

  Widget _buildTitle() {
    final keyTail = widget.showRate ? 'reviewTitle' : 'problemTitle';
    return Text(
      tr(
        'ReviewDeliveryAsSellerScreen.' + keyTail,
        namedArgs: {'customerFirstName': widget.delivery.customer.firstName},
      ),
    );
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }
}
