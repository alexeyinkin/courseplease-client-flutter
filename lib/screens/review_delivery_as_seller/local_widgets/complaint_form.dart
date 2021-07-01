import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/screens/review_delivery_as_seller/local_blocs/review_delivery_as_seller.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ComplaintFormAsSellerWidget extends StatelessWidget {
  final ReviewDeliveryAsSellerScreenCubit cubit;
  final Delivery delivery;
  final ReviewDeliveryScreenCubitState state;

  ComplaintFormAsSellerWidget({
    required this.cubit,
    required this.delivery,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.showComplaint) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallPadding(),
        SmallPadding(),
        Text(tr('ReviewDeliveryAsSellerScreen.complaintLabel')),
        SmallPadding(),
        AppTextField(
          controller: state.complaintController,
          hintText: tr('ReviewDeliveryAsSellerScreen.complaintHint'),
          maxLines: 3,
        ),
        CheckboxListTile(
          value: state.contactMe,
          title: Text(tr('ReviewDeliveryAsSellerScreen.contactMe')),
          onChanged: cubit.setContactMe,
        ),
      ],
    );
  }
}
