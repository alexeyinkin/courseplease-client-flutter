import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ReviewDeliveryAsCustomerScreenCubit extends Bloc {
  final _outStateController = BehaviorSubject<ReviewDeliveryAsCustomerScreenCubitState>();
  Stream<ReviewDeliveryAsCustomerScreenCubitState> get outState => _outStateController.stream;

  final _outResultController = BehaviorSubject<DialogResult>();
  Stream<DialogResult> get outResult => _outResultController.stream;

  final _cache = GetIt.instance.get<FilteredModelListCache>();

  final int deliveryId;
  final bool showRate;
  int? _intStarRating;
  final _reviewController = TextEditingController();
  final _complaintController = TextEditingController();
  bool _contactMe = false;
  bool _refund = false;
  bool _inProgress = false;
  bool _isComplaintEmpty = true;

  late final ReviewDeliveryAsCustomerScreenCubitState initialState;

  static const _maxRatingToReport = 2;
  static const maxStarCount = 5;

  ReviewDeliveryAsCustomerScreenCubit({
    required this.deliveryId,
    required this.showRate,
  }) {
    initialState = _createState();
    _complaintController.addListener(_onComplaintChange);
  }

  void _onComplaintChange() {
    final newEmpty = (_complaintController.text == '');
    if (newEmpty != _isComplaintEmpty) {
      _isComplaintEmpty = newEmpty;
      _pushOutput();
    }
  }

  void setIntStarRating(int intStarRating) {
    _intStarRating = intStarRating;
    _pushOutput();
  }

  void setContactMe(bool? value) {
    _contactMe = (value ?? false) || _refund;
    _pushOutput();
  }

  void setRefund(bool? value) {
    if (value ?? false) {
      _contactMe = true;
    }
    _refund = value ?? false;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(_createState());
  }

  ReviewDeliveryAsCustomerScreenCubitState _createState() {
    return ReviewDeliveryAsCustomerScreenCubitState(
      showRate: showRate,
      intStarRating: _intStarRating,
      ratingTip: tr('ReviewDeliveryAsCustomerScreen.rating' + (_intStarRating ?? 0).toString()),
      reviewController: _reviewController,
      complaintController: _complaintController,
      contactMe: _contactMe,
      refund: _refund,
      showComplaint: _shouldShowComplaint(),
      inProgress: _inProgress,
      canSubmit: _canSubmit(),
    );
  }

  bool _canSubmit() {
    if (showRate) {
      return _intStarRating != null;
    }

    return !_isComplaintEmpty;
  }

  bool _shouldShowComplaint() {
    if (!showRate) return true;
    return _intStarRating != null && _intStarRating! <= _maxRatingToReport;
  }

  void submit() async {
    _inProgress = true;
    _pushOutput();

    final request = ReviewDeliveryRequest(
      deliveryId: deliveryId,
      action: enumValueAfterDot(_getAction()),
      reviewBody: _getReviewBody(),
      complaintBody: _getComplaintBody(),
    );

    final _apiClient = GetIt.instance.get<ApiClient>();

    try {
      await _apiClient.reviewDelivery(request);
      _onComplete();
    } catch (ex) {
      // TODO: Show message, log error.
      _outResultController.sink.add(DialogResult(code: DialogResultCode.error));
    }
  }

  ReviewDeliveryAction _getAction() {
    final canComplain = _shouldShowComplaint();

    if (_refund && canComplain) {
      return ReviewDeliveryAction.dispute;
    }

    if (showRate) {
      return ReviewDeliveryAction.approve;
    }

    return ReviewDeliveryAction.feedback;
  }

  DeliveryReviewBodyRequest? _getReviewBody() {
    if (!showRate) return null;

    return DeliveryReviewBodyRequest(
      rating: _getNormalizedRating(),
      text: _reviewController.text,
    );
  }

  DeliveryComplaintBodyRequest? _getComplaintBody() {
    if (!_shouldShowComplaint()) return null;
    if (_isComplaintEmpty && !_contactMe) return null;

    return DeliveryComplaintBodyRequest(
      text: _complaintController.text,
      contactMe: _contactMe,
    );
  }

  double _getNormalizedRating() {
    return _intStarRating! / maxStarCount;
  }

  void _onComplete() {
    _reloadDeliveries();
    // TODO: Reload reviews when we introduce them as models.

    _outResultController.sink.add(
      DialogResult(code: DialogResultCode.ok),
    );
  }

  void _reloadDeliveries() {
    // TODO: Not all?
    final deliveryLists = _cache.getModelListsByObjectAndFilterTypes<int, Delivery, DeliveryFilter>();

    for (final list in deliveryLists.values) {
      list.clearAndLoadFirstPage();
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _complaintController.dispose();
    _outResultController.close();
    _outStateController.close();
  }
}

class ReviewDeliveryAsCustomerScreenCubitState {
  final bool showRate;
  final int? intStarRating;
  final String ratingTip;
  final TextEditingController reviewController;
  final TextEditingController complaintController;
  final bool contactMe;
  final bool refund;
  final bool showComplaint;
  final bool inProgress;
  final bool canSubmit;

  ReviewDeliveryAsCustomerScreenCubitState({
    required this.showRate,
    required this.intStarRating,
    required this.ratingTip,
    required this.reviewController,
    required this.complaintController,
    required this.contactMe,
    required this.refund,
    required this.showComplaint,
    required this.inProgress,
    required this.canSubmit,
  });
}
