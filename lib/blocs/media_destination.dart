import 'dart:async';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'authentication.dart';

class MediaDestinationCubit extends Bloc {
  final _outStateController = BehaviorSubject<MediaDestinationState>();
  Stream<MediaDestinationState> get outState => _outStateController.stream;

  final _outActionController = StreamController<MediaDestinationState>();
  Stream<MediaDestinationState> get outAction => _outActionController.stream;

  final _authenticationBloc = GetIt.instance.get<AuthenticationBloc>();
  StreamSubscription _authenticationBlocSubscription;

  final _productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();
  StreamSubscription _productSubjectCacheSubscription;

  final initialState = MediaDestinationState(
    canSubmit: false,
    purposeId: null,
    showPurposeIds: [],
    subjectId: null,
    showSubjectIds: [],
    inProgress: false,
  );

  AuthenticationState _authenticationState;
  Map<int, ProductSubject> _productSubjects;
  int _purposeId; // Nullable
  int _subjectId; // Nullable
  List<int> _showSubjectIds; // Nullable
  Future _requestFuture; // Nullable

  static const _allPurposes = [
    ImageAlbumPurpose.portfolio,
    ImageAlbumPurpose.customersPortfolio,
    ImageAlbumPurpose.backstage,
  ];

  static const _nonPortfolioPurposes = [
    ImageAlbumPurpose.backstage,
  ];

  MediaDestinationCubit() {
    _authenticationBlocSubscription = _authenticationBloc.outState.listen(_onAuthenticationChange);
    _productSubjectCacheSubscription = _productSubjectCacheBloc.outObjectsByIds.listen(_onProductSubjectsChange);
  }

  void _onAuthenticationChange(AuthenticationState authenticationState) {
    _authenticationState = authenticationState;
    _updateShowSubjectIds();
    _pushOutput();
  }

  void _onProductSubjectsChange(Map<int, ProductSubject> productSubjects) {
    _productSubjects = productSubjects;
    _updateShowSubjectIds();
    _pushOutput();
  }

  void _updateShowSubjectIds() {
    if (_authenticationState == null || _productSubjects == null) {
      return;
    }

    _showSubjectIds = _getShowSubjectIds(_authenticationState.teacherSubjectIds);

    if (_showSubjectIds.length == 1 && _subjectId == null) {
      _subjectId = _showSubjectIds[0];
    }
  }

  void _pushOutput() {
    if (!_isLoaded()) return;
    _outStateController.sink.add(_createState());
  }

  bool _isLoaded() {
    if (_productSubjects == null) return false;
    if (_showSubjectIds == null) return false;
    return true;
  }

  MediaDestinationState _createState() {
    return MediaDestinationState(
      canSubmit: _getCanSubmit(),
      purposeId: _getEffectivePurposeId(),
      showPurposeIds: _getShowPurposeIds(),
      subjectId: _subjectId,
      showSubjectIds: _showSubjectIds,
      inProgress: _requestFuture != null,
    );
  }

  bool _getCanSubmit() {
    if (_subjectId == null) return false;
    if (_getEffectivePurposeId() == null) return false;
    return true;
  }

  int _getEffectivePurposeId() { // Nullable
    final showPurposeIds = _getShowPurposeIds();
    if (showPurposeIds.length == 1) {
      return showPurposeIds[0];
    }
    return _purposeId;
  }

  List<int> _getShowPurposeIds() {
    if (_productSubjects == null || _subjectId == null) {
      return [];
    }

    final ps = _productSubjects[_subjectId];
    return ps.allowsImagePortfolio ? _allPurposes : _nonPortfolioPurposes;
  }

  List<int> _getShowSubjectIds(List<int> teacherSubjectIds) {
    final showIds = <int>[];

    for (final id in teacherSubjectIds) {
      if (!_productSubjects.containsKey(id)) {
        // A disabled subject for which the user has a display.
        // Disabled subjects do not come from server.
        continue;
      }
      showIds.add(id);
    }
    return showIds;
  }

  void setPurposeId(int purposeId) {
    if (_purposeId == purposeId) return;
    _purposeId = purposeId;
    _pushOutput();
  }

  void setSubjectId(int subjectId) {
    if (_productSubjects == null) return;

    bool changed = false;
    final ps = _productSubjects[subjectId];

    if (!ps.allowsImagePortfolio && _isPurposeAPortfolio(_purposeId)) {
      _purposeId = ImageAlbumPurpose.backstage;
      changed = true;
    }

    if (_subjectId != subjectId) {
      _subjectId = subjectId;
      changed = true;
    }

    if (changed) {
      _pushOutput();
    }
  }

  bool _isPurposeAPortfolio(int purposeId) {
    switch (purposeId) {
      case ImageAlbumPurpose.portfolio:
      case ImageAlbumPurpose.customersPortfolio:
        return true;
    }

    return false;
  }

  void onActionPressed() {
    _outActionController.sink.add(_createState());
  }

  @override
  void dispose() {
    _productSubjectCacheSubscription.cancel();
    _authenticationBlocSubscription.cancel();
    _outActionController.close();
    _outStateController.close();
  }
}

class MediaDestinationState {
  final bool canSubmit;
  final int purposeId; // Nullable
  final List<int> showPurposeIds;
  final int subjectId; // Nullable
  final List<int> showSubjectIds;
  final bool inProgress;

  MediaDestinationState({
    this.canSubmit,
    this.purposeId,
    this.showPurposeIds,
    this.subjectId,
    this.showSubjectIds,
    this.inProgress,
  });
}

enum PurposeEnum {
  portfolio,
  customersPortfolio,
  backstage,
}
