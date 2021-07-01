import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery_as_customer/local_blocs/review_delivery_as_customer.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ComplaintFormAsCustomerWidget extends StatelessWidget {
  final ReviewDeliveryAsCustomerScreenCubit cubit;
  final Delivery delivery;
  final ReviewDeliveryAsCustomerScreenCubitState state;

  ComplaintFormAsCustomerWidget({
    required this.cubit,
    required this.delivery,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
            namedArgs: {'teacherFirstName': delivery.seller.firstName},
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
          onChanged: cubit.setContactMe,
        ),
        CheckboxListTile(
          value: state.refund,
          title: Text(tr('ReviewDeliveryAsCustomerScreen.refund')),
          onChanged: cubit.setRefund,
        ),
      ],
    );
  }
}
