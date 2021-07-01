import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/screens/review_delivery/local_blocs/review_delivery.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

class ReviewDeliveryAsSellerScreenCubit extends AbstractReviewDeliveryScreenCubit<ReviewDeliveryScreenCubitState> {
  ReviewDeliveryAsSellerScreenCubit({
    required Delivery delivery,
    required bool showRate,
  }) : super(
    delivery: delivery,
    showRate: showRate,
  );

  ReviewDeliveryScreenCubitState wrapState(ReviewDeliveryScreenCubitState state) {
    return state;
  }

  @override
  Future<void> submitRequest(ReviewDeliveryScreenCubitState state) async {
    final request = ReviewDeliveryRequest(
      deliveryId: delivery.id,
      action: enumValueAfterDot(_getAction()),
      reviewBody: getReviewBody(),
      complaintBody: getComplaintBody(),
    );

    final _apiClient = GetIt.instance.get<ApiClient>();
    return _apiClient.reviewDeliveryAsSeller(request);
  }

  ReviewDeliveryActionAsSeller _getAction() {
    if (showRate) {
      return ReviewDeliveryActionAsSeller.review;
    }

    return ReviewDeliveryActionAsSeller.feedback;
  }
}

enum ReviewDeliveryActionAsSeller {
  review,
  feedback,
}
