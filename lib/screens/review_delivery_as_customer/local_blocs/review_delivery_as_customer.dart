import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ReviewDeliveryAsCustomerScreenCubit extends AbstractReviewDeliveryScreenCubit<ReviewDeliveryAsCustomerScreenCubitState> {
  bool _refund = false;

  ReviewDeliveryAsCustomerScreenCubit({
    required int deliveryId,
    required bool showRate,
  }) : super(
    deliveryId: deliveryId,
    showRate: showRate,
  );

  void setContactMe(bool? value) {
    value = (value ?? false) || _refund;
    super.setContactMe(value);
  }

  void setRefund(bool? value) {
    _refund = value ?? false;

    if (_refund) {
      setContactMe(true); // Pushes _refund as well.
    } else {
      pushOutput();
    }
  }

  @override
  ReviewDeliveryAsCustomerScreenCubitState wrapState(ReviewDeliveryScreenCubitState state) {
    return ReviewDeliveryAsCustomerScreenCubitState(
      base: state,
      refund: _refund,
    );
  }

  @override
  Future<void> submitRequest(ReviewDeliveryAsCustomerScreenCubitState state) async {
    final request = ReviewDeliveryRequest(
      deliveryId: deliveryId,
      action: enumValueAfterDot(_getAction(state)),
      reviewBody: getReviewBody(),
      complaintBody: getComplaintBody(),
    );

    final _apiClient = GetIt.instance.get<ApiClient>();
    return _apiClient.reviewDeliveryAsCustomer(request);
  }

  ReviewDeliveryActionAsCustomer _getAction(ReviewDeliveryAsCustomerScreenCubitState state) {
    if (_refund && state.showComplaint) {
      return ReviewDeliveryActionAsCustomer.dispute;
    }

    if (showRate) {
      return ReviewDeliveryActionAsCustomer.approve;
    }

    return ReviewDeliveryActionAsCustomer.feedback;
  }
}

enum ReviewDeliveryActionAsCustomer {
  approve,
  dispute,
  feedback,
}

class ReviewDeliveryAsCustomerScreenCubitState implements ReviewDeliveryScreenCubitState {
  final ReviewDeliveryScreenCubitState base;
  final bool refund;

  bool                  get showRate            => base.showRate;
  int?                  get intStarRating       => base.intStarRating;
  String                get ratingTip           => base.ratingTip;
  TextEditingController get reviewController    => base.reviewController;
  TextEditingController get complaintController => base.complaintController;
  bool                  get contactMe           => base.contactMe;
  bool                  get showComplaint       => base.showComplaint;
  bool                  get inProgress          => base.inProgress;
  bool                  get canSubmit           => base.canSubmit;

  ReviewDeliveryAsCustomerScreenCubitState({
    required this.base,
    required this.refund,
  });
}
