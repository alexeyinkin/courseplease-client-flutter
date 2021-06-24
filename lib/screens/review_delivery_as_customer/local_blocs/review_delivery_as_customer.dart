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
  int? _intStarRating;
  final _reviewController = TextEditingController();
  final _privateController = TextEditingController();
  bool _inProgress = false;

  late final ReviewDeliveryAsCustomerScreenCubitState initialState;

  static const _maxRatingToReport = 2;
  static const maxStarCount = 5;

  ReviewDeliveryAsCustomerScreenCubit({
    required this.deliveryId,
  }) {
    initialState = _createState();
  }

  void setIntStarRating(int intStarRating) {
    _intStarRating = intStarRating;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(_createState());
  }

  ReviewDeliveryAsCustomerScreenCubitState _createState() {
    return ReviewDeliveryAsCustomerScreenCubitState(
      intStarRating: _intStarRating,
      ratingTip: tr('ReviewDeliveryAsCustomerScreen.rating' + (_intStarRating ?? 0).toString()),
      reviewController: _reviewController,
      reportController: _privateController,
      canReport: _canReport(),
      inProgress: _inProgress,
      canSubmit: _canSubmit(),
    );
  }

  bool _canSubmit() {
    return _intStarRating != null;
  }

  bool _canReport() {
    return _intStarRating != null && _intStarRating! <= _maxRatingToReport;
  }

  void submit() async {
    _inProgress = true;
    _pushOutput();

    final request = ReviewDeliveryRequest(
      deliveryId: deliveryId,
      action: enumValueAfterDot(_getAction()),
      body: ReviewBodyRequest(
        rating: _getNormalizedRating(),
        text: _reviewController.text,
      ),
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

  ReviewDeliveryAction _getAction() {
    if (_canReport()) {
      return ReviewDeliveryAction.dispute;
    }
    return ReviewDeliveryAction.approve;
  }

  double _getNormalizedRating() {
    return _intStarRating! / maxStarCount;
  }

  @override
  void dispose() {
    _outResultController.close();
    _outStateController.close();
  }
}

class ReviewDeliveryAsCustomerScreenCubitState {
  final int? intStarRating;
  final String ratingTip;
  final TextEditingController reviewController;
  final TextEditingController reportController;
  final bool canReport;
  final bool inProgress;
  final bool canSubmit;

  ReviewDeliveryAsCustomerScreenCubitState({
    required this.intStarRating,
    required this.ratingTip,
    required this.reviewController,
    required this.reportController,
    required this.canReport,
    required this.inProgress,
    required this.canSubmit,
  });
}
