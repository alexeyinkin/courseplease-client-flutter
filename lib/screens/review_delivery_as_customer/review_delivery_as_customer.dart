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
    deliveryId: delivery.id,
    showRate: showRate,
  );
}

class _ReviewDeliveryAsCustomerScreenState extends State<ReviewDeliveryAsCustomerScreen> {
  final ReviewDeliveryAsCustomerScreenCubit _cubit;

  _ReviewDeliveryAsCustomerScreenState({
    required int deliveryId,
    required bool showRate,
  }) :
      _cubit = ReviewDeliveryAsCustomerScreenCubit(
        deliveryId: deliveryId,
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
    return AlertDialog(
      title: _getTitleWidget(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getReviewSectionIfNeed(state),
          _getComplaintSectionIfNeed(state),
        ],
      ),
      actions: _getButtons(state),
    );
  }

  Widget _getTitleWidget() {
    final keyTail = widget.showRate ? 'reviewTitle' : 'problemTitle';
    return Text(
      tr(
        'ReviewDeliveryAsCustomerScreen.' + keyTail,
        namedArgs: {'teacherFirstName': widget.delivery.author.firstName},
      ),
    );
  }

  Widget _getReviewSectionIfNeed(ReviewDeliveryAsCustomerScreenCubitState state) {
    if (!state.showRate) return Container();

    return Column(
      children: [
        _getRatingBarWidget(state),
        Container(height: 5),
        Text(state.ratingTip, style: AppStyle.minor),
        Container(height: 15),
        _getReviewField(state),
      ],
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
      hintText: tr(
        'ReviewDeliveryAsCustomerScreen.reviewHint',
        namedArgs: {'teacherFirstName': widget.delivery.author.firstName},
      ),
      maxLines: 3,
    );
  }

  Widget _getComplaintSectionIfNeed(ReviewDeliveryAsCustomerScreenCubitState state) {
    if (!state.showComplaint) return Container();

    final reportTitleTailKey = state.refund
        ? 'refundComplaintLabel'
        : 'complaintLabel';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallPadding(),
        SmallPadding(),
        Text(
          tr(
            'ReviewDeliveryAsCustomerScreen.' + reportTitleTailKey,
            namedArgs: {'teacherFirstName': widget.delivery.author.firstName},
          ),
        ),
        SmallPadding(),
        AppTextField(
          controller: state.complaintController,
          hintText: tr('ReviewDeliveryAsCustomerScreen.complaintHint'),
          maxLines: 3,
        ),
        CheckboxListTile(
          value: state.contactMe,
          title: Text(tr('ReviewDeliveryAsCustomerScreen.contactMe')),
          onChanged: _cubit.setContactMe,
        ),
        CheckboxListTile(
          value: state.refund,
          title: Text(tr('ReviewDeliveryAsCustomerScreen.refund')),
          onChanged: _cubit.setRefund,
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

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }
}
