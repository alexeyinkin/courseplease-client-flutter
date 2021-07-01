import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

abstract class AbstractReviewDeliveryScreenCubit<S extends ReviewDeliveryScreenCubitState> extends Bloc {
  final _outStateController = BehaviorSubject<S>();
  Stream<S> get outState => _outStateController.stream;

  final _outResultController = BehaviorSubject<DialogResult>();
  Stream<DialogResult> get outResult => _outResultController.stream;

  final _cache = GetIt.instance.get<FilteredModelListCache>();

  final int deliveryId;
  final bool showRate;
  int? _intStarRating;
  final _reviewController = TextEditingController();
  final _complaintController = TextEditingController();
  bool _contactMe = false;
  bool _inProgress = false;
  bool _isComplaintEmpty = true;

  late final S initialState;

  static const _maxRatingToReport = 2;
  static const maxStarCount = 5;

  AbstractReviewDeliveryScreenCubit({
    required this.deliveryId,
    required this.showRate,
  }) {
    initialState = createAndWrapState();
    _complaintController.addListener(_onComplaintChange);
  }

  void _onComplaintChange() {
    final newEmpty = (_complaintController.text == '');
    if (newEmpty != _isComplaintEmpty) {
      _isComplaintEmpty = newEmpty;
      pushOutput();
    }
  }

  void setIntStarRating(int intStarRating) {
    _intStarRating = intStarRating;
    pushOutput();
  }

  void setContactMe(bool? value) {
    _contactMe = value ?? false;
    pushOutput();
  }

  void pushOutput() {
    _outStateController.sink.add(createAndWrapState());
  }

  ReviewDeliveryScreenCubitState _createState() {
    return ReviewDeliveryScreenCubitState(
      showRate: showRate,
      intStarRating: _intStarRating,
      ratingTip: tr('ReviewDeliveryScreen.rating' + (_intStarRating ?? 0).toString()),
      reviewController: _reviewController,
      complaintController: _complaintController,
      contactMe: _contactMe,
      showComplaint: shouldShowComplaint(),
      inProgress: _inProgress,
      canSubmit: _canSubmit(),
    );
  }

  S createAndWrapState() {
    return wrapState(_createState());
  }

  S wrapState(ReviewDeliveryScreenCubitState state);

  bool _canSubmit() {
    if (showRate) {
      return _intStarRating != null;
    }

    return !_isComplaintEmpty;
  }

  bool shouldShowComplaint() {
    if (!showRate) return true;
    return _intStarRating != null && _intStarRating! <= _maxRatingToReport;
  }

  void submit() async {
    _inProgress = true;
    pushOutput();

    try {
      final state = createAndWrapState();
      await submitRequest(state);
      _onComplete();
    } catch (ex) {
      // TODO: Show message, log error.
      _outResultController.sink.add(DialogResult(code: DialogResultCode.error));
    }
  }

  Future<void> submitRequest(S state);

  DeliveryReviewBodyRequest? getReviewBody() {
    if (!showRate) return null;

    return DeliveryReviewBodyRequest(
      rating: _getNormalizedRating(),
      text: _reviewController.text,
    );
  }

  DeliveryComplaintBodyRequest? getComplaintBody() {
    if (!shouldShowComplaint()) return null;
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

class ReviewDeliveryScreenCubitState {
  final bool showRate;
  final int? intStarRating;
  final String ratingTip;
  final TextEditingController reviewController;
  final TextEditingController complaintController;
  final bool contactMe;
  final bool showComplaint;
  final bool inProgress;
  final bool canSubmit;

  ReviewDeliveryScreenCubitState({
    required this.showRate,
    required this.intStarRating,
    required this.ratingTip,
    required this.reviewController,
    required this.complaintController,
    required this.contactMe,
    required this.showComplaint,
    required this.inProgress,
    required this.canSubmit,
  });
}
