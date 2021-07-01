import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDeliveryScreen<
  S extends ReviewDeliveryScreenCubitState,
  C extends AbstractReviewDeliveryScreenCubit<S>
> extends StatelessWidget {
  final C cubit;
  final Delivery delivery;
  final bool showRate;
  final Widget title;
  final Widget complaintForm;
  final User otherUser;

  ReviewDeliveryScreen({
    required this.cubit,
    required this.delivery,
    required this.showRate,
    required this.title,
    required this.complaintForm,
    required this.otherUser,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: cubit.outState,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? cubit.initialState,
      ),
    );
  }

  Widget _buildWithState(S state) {
    return AlertDialog(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getReviewSectionIfNeed(state),
          complaintForm,
        ],
      ),
      actions: _getButtons(state),
    );
  }


  Widget _getReviewSectionIfNeed(S state) {
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

  Widget _getRatingBarWidget(S state) {
    return RatingBar.builder(
      itemBuilder: (_, __) => Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (d) => cubit.setIntStarRating(d.floor()),
      initialRating: state.intStarRating?.toDouble() ?? 0,
      minRating: 1,
      itemCount: AbstractReviewDeliveryScreenCubit.maxStarCount,
    );
  }

  Widget _getReviewField(S state) {
    return AppTextField(
      controller: state.reviewController,
      hintText: tr(
        'ReviewDeliveryScreen.reviewHint',
        namedArgs: {'firstName': otherUser.firstName},
      ),
      maxLines: 3,
    );
  }

  List<Widget> _getButtons(S state) {
    return [
      ElevatedButtonWithProgress(
        child: Text(tr('ReviewDeliveryScreen.submit')),
        isLoading: state.inProgress,
        onPressed: cubit.submit,
        enabled: state.canSubmit,
      ),
    ];
  }
}
