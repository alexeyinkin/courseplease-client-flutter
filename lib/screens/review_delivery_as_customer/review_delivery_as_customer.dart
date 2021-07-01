import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery/review_delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/local_blocs/review_delivery_as_customer.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'local_widgets/complaint_form.dart';

class ReviewDeliveryAsCustomerScreen extends StatefulWidget {
  final Delivery delivery;
  final bool showRate;

  ReviewDeliveryAsCustomerScreen({
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
      builder: (context) => ReviewDeliveryAsCustomerScreen(
        delivery: delivery,
        showRate: showRate,
      ),
    );
  }

  @override
  _ReviewDeliveryAsCustomerScreenState createState() => _ReviewDeliveryAsCustomerScreenState(
    delivery: delivery,
    showRate: showRate,
  );
}

class _ReviewDeliveryAsCustomerScreenState extends State<ReviewDeliveryAsCustomerScreen> {
  final ReviewDeliveryAsCustomerScreenCubit _cubit;

  _ReviewDeliveryAsCustomerScreenState({
    required Delivery delivery,
    required bool showRate,
  }) :
      _cubit = ReviewDeliveryAsCustomerScreenCubit(
        delivery: delivery,
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
    return StreamBuilder<ReviewDeliveryAsCustomerScreenCubitState>(
      stream: _cubit.outState,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? _cubit.initialState,
      ),
    );
  }

  Widget _buildWithState(ReviewDeliveryAsCustomerScreenCubitState state) {
    return ReviewDeliveryScreen(
      cubit: _cubit,
      delivery: widget.delivery,
      showRate: widget.showRate,
      title: _buildTitle(),
      complaintForm: ComplaintFormAsCustomerWidget(
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
        'ReviewDeliveryAsCustomerScreen.' + keyTail,
        namedArgs: {'teacherFirstName': widget.delivery.seller.firstName},
      ),
    );
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }
}
