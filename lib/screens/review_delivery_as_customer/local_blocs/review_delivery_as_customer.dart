import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ReviewDeliveryAsCustomerScreenCubit extends AbstractReviewDeliveryScreenCubit<ReviewDeliveryAsCustomerScreenCubitState> {
  bool _refund = false;

  ReviewDeliveryAsCustomerScreenCubit({
    required Delivery delivery,
    required bool showRate,
  }) : super(
    delivery: delivery,
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
      deliveryId: delivery.id,
      action: enumValueAfterDot(_getAction(state)),
      reviewBody: getReviewBody(),
      complaintBody: getComplaintBody(),
    );

    final apiClient = GetIt.instance.get<ApiClient>();
    final result = await apiClient.reviewDeliveryAsCustomer(request);

    _reloadTeacherAndAllTeacherLists();

    return result;
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

  void _reloadTeacherAndAllTeacherLists() {
    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, Teacher, TeacherFilter>();

    for (final list in lists.values) {
      list.clear();
    }

    final modelCacheBloc = GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>();
    modelCacheBloc.removeId(delivery.seller.id);
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
