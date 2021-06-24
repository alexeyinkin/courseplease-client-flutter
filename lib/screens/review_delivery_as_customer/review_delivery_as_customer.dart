import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/local_blocs/review_delivery_as_customer.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDeliveryAsCustomerScreen extends StatefulWidget {
  final Delivery delivery;

  ReviewDeliveryAsCustomerScreen({
    required this.delivery,
  });

  static Future<DialogResult?> show({
    required BuildContext context,
    required Delivery delivery,
  }) async {
    return showDialog<DialogResult>(
      context: context,
      builder: (context) => ReviewDeliveryAsCustomerScreen(
        delivery: delivery,
      ),
    );
  }

  @override
  _ReviewDeliveryAsCustomerScreenState createState() => _ReviewDeliveryAsCustomerScreenState(
    deliveryId: delivery.id,
  );
}

class _ReviewDeliveryAsCustomerScreenState extends State<ReviewDeliveryAsCustomerScreen> {
  final ReviewDeliveryAsCustomerScreenCubit _cubit;

  _ReviewDeliveryAsCustomerScreenState({
    required int deliveryId,
  }) :
      _cubit = ReviewDeliveryAsCustomerScreenCubit(deliveryId: deliveryId)
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
    return AlertDialog(
      title: _getTitleWidget(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getRatingBarWidget(state),
          Container(height: 5),
          Text(state.ratingTip, style: AppStyle.minor),
          Container(height: 15),
          _getReviewField(state),
          _showReportIfNeed(state),
        ],
      ),
      actions: _getButtons(state),
    );
  }

  Widget _getTitleWidget() {
    return Text(
      tr(
        'ReviewDeliveryAsCustomerScreen.title',
        namedArgs: {'teacherFirstName': widget.delivery.author.firstName},
      ),
    );
  }

  Widget _getRatingBarWidget(ReviewDeliveryAsCustomerScreenCubitState state) {
    return RatingBar.builder(
      itemBuilder: (_, __) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (d) => _cubit.setIntStarRating(d.floor()),
      initialRating: state.intStarRating?.toDouble() ?? 0,
      minRating: 1,
      itemCount: ReviewDeliveryAsCustomerScreenCubit.maxStarCount,
    );
  }

  Widget _getReviewField(ReviewDeliveryAsCustomerScreenCubitState state) {
    return AppTextField(
      controller: state.reviewController,
      hintText: tr('ReviewDeliveryAsCustomerScreen.reviewHint'),
      maxLines: 3,
    );
  }

  Widget _showReportIfNeed(ReviewDeliveryAsCustomerScreenCubitState state) {
    if (!state.canReport) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallPadding(),
        SmallPadding(),
        Text(tr('ReviewDeliveryAsCustomerScreen.reportTitle')),
        AppTextField(
          controller: state.reportController,
          hintText: tr('ReviewDeliveryAsCustomerScreen.reportHint'),
          maxLines: 3,
        ),
      ],
    );
  }

  List<Widget> _getButtons(ReviewDeliveryAsCustomerScreenCubitState state) {
    return [
      ElevatedButtonWithProgress(
        child: Text(tr('ReviewDeliveryAsCustomerScreen.submit')),
        isLoading: state.inProgress,
        onPressed: _cubit.submit,
        enabled: state.canSubmit,
      ),
    ];
  }
}
