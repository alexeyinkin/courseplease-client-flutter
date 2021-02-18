import 'dart:async';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class EditImageListCubit extends Bloc {
  final SelectableListCubit _listStateCubit;
  StreamSubscription _selectionCubitSubscription;

  final _authenticationBloc = GetIt.instance.get<AuthenticationBloc>();
  StreamSubscription _authenticationBlocSubscription;

  final _productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();
  StreamSubscription _productSubjectCacheSubscription;

  final _outStateController = BehaviorSubject<EditImageListState>();
  Stream<EditImageListState> get outState => _outStateController.stream;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  EditImageFilter _filter; // Nullable
  SelectableListState _selectionState;
  AuthenticationState _authenticationState;
  Map<int, ProductSubject> _productSubjects;
  EditImageListMode _mode; // Nullable
  PublishAction _action; // Nullable
  int _subjectId; // Nullable
  Future _requestFuture; // Nullable

  final initialState = EditImageListState(
    mode: EditImageListMode.normal,
    canPublish: false,
    action: null,
    showActions: _allActions,
    subjectId: null,
    showSubjectIds: [],
    canDelete: false,
    inProgress: false,
  );

  static const _mediaType = 'image';

  static const _allActions = [
    PublishAction.portfolio,
    PublishAction.customersPortfolio,
    PublishAction.backstage,
  ];

  static const _nonPortfolioActions = [
    PublishAction.backstage,
  ];

  EditImageListCubit({
    @required SelectableListCubit listStateCubit,
  }) :
      _listStateCubit = listStateCubit
  {
    _selectionCubitSubscription = _listStateCubit.outState.listen(_onSelectionChange);
    _authenticationBlocSubscription = _authenticationBloc.outState.listen(_onAuthenticationChange);
    _productSubjectCacheSubscription = _productSubjectCacheBloc.outObjectsByIds.listen(_onProductSubjectsChange);
  }

  void _onSelectionChange(SelectableListState selectionState) {
    _selectionState = selectionState;
    _pushOutput();
  }

  void _onAuthenticationChange(AuthenticationState authenticationState) {
    _authenticationState = authenticationState;
    _pushOutput();
  }

  void _onProductSubjectsChange(Map<int, ProductSubject> productSubjects) {
    _productSubjects = productSubjects;
    _pushOutput();
  }

  void setFilter(EditImageFilter filter) {
    _filter = filter;
    _mode = _getModeFromFilter(filter);
    _pushOutput();
  }

  EditImageListMode _getModeFromFilter(EditImageFilter filter) {
    if (filter.unsorted) return EditImageListMode.unsorted;
    return EditImageListMode.normal;
  }

  void setAction(PublishAction action) {
    if (_action == action) return;
    _action = action;
    _pushOutput();
  }

  void setSubjectId(int subjectId) {
    if (_productSubjects == null) return;

    bool changed = false;
    final ps = _productSubjects[subjectId];

    if (!ps.allowsImagePortfolio && _isActionPortfolio(_action)) {
      _action = PublishAction.backstage;
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

  bool _isActionPortfolio(PublishAction action) {
    switch (action) {
      case PublishAction.portfolio:
      case PublishAction.customersPortfolio:
        return true;
      default:
        return false;
    }
  }

  void _pushOutput() {
    if (!_isLoaded()) return;

    final state = EditImageListState(
      mode: _mode,
      canPublish: _getCanPublish(),
      action: _action,
      showActions: _getShowActions(),
      subjectId: _subjectId,
      showSubjectIds: _authenticationState.teacherSubjectIds,
      canDelete: _getCanDelete(),
      inProgress: _requestFuture != null,
    );
    _outStateController.sink.add(state);
  }

  bool _isLoaded() {
    if (_productSubjects == null) return false;
    if (_selectionState == null) return false;
    if (_mode == null) return false;
    return true;
  }

  bool _getCanPublish() {
    if (_selectionState == null || !_selectionState.selected) return false;
    if (_action == null) return false;
    if (_subjectId == null) return false;
    if (_requestFuture != null) return false;
    return true;
  }

  bool _getCanDelete() {
    if (_selectionState == null || !_selectionState.selected) return false;
    if (_requestFuture != null) return false;
    return true;
  }

  List<PublishAction> _getShowActions() {
    if (_productSubjects == null || _subjectId == null) {
      return _allActions;
    }

    final ps = _productSubjects[_subjectId];
    return ps.allowsImagePortfolio ? _allActions : _nonPortfolioActions;
  }

  void publishSelected() {
    if (_requestFuture != null) return;
    _requestFuture = _apiClient.sortUnsortedMedia(_getPublishRequest());
    _afterRequestFuture();
    _pushOutput();
  }

  MediaSortRequest _getPublishRequest() {
    final commands = <MediaSortCommand>[];
    for (final id in _selectionState.selectedIds.keys) {
      commands.add(_getPublishCommand(id));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getPublishCommand(int id) {
    return MediaSortCommand(
      type: _mediaType,
      id: id,
      action: enumValueAfterDot(_action),
      subjectId: _subjectId,
    );
  }

  void deleteSelected() {
    if (_requestFuture != null) return;
    _requestFuture = _apiClient.sortUnsortedMedia(_getDeleteRequest());
    _afterRequestFuture();
    _pushOutput();
  }

  MediaSortRequest _getDeleteRequest() {
    final commands = <MediaSortCommand>[];
    for (final id in _selectionState.selectedIds.keys) {
      commands.add(_getDeleteCommand(id));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getDeleteCommand(int id) {
    return MediaSortCommand(
      type: _mediaType,
      id: id,
      action: enumValueAfterDot(PublishAction.delete),
    );
  }

  void _afterRequestFuture() {
    _requestFuture
        .then(_onRequestSuccess)
        .catchError(_onRequestError);
  }

  void _onRequestSuccess(_) {
    _requestFuture = null;
    _removeSortedFromModelLists();
    _listStateCubit.selectNone(); // This will push output.
  }

  void _removeSortedFromModelLists() {
    final lists = _filteredModelListCache.getModelListsByObjectAndFilterTypes<ImageEntity, EditImageFilter>();

    for (final list in lists.values) {
      list.removeObjectIds(_selectionState.selectedIds.keys.toList());
    }
  }

  void _onRequestError(_) {
    _requestFuture = null;
    _pushOutput();
    // TODO: Push some error message somewhere.
  }

  @override
  void dispose() {
    _productSubjectCacheSubscription.cancel();
    _authenticationBlocSubscription.cancel();
    _selectionCubitSubscription.cancel();
    _outStateController.close();
  }
}

class EditImageListState {
  final EditImageListMode mode;
  final bool canPublish;
  final PublishAction action; // Nullable
  final List<PublishAction> showActions;
  final int subjectId; // Nullable
  final List<int> showSubjectIds;
  final bool canDelete;
  final bool inProgress;

  EditImageListState({
    @required this.mode,
    @required this.canPublish,
    @required this.action,
    @required this.showActions,
    @required this.subjectId,
    @required this.showSubjectIds,
    @required this.canDelete,
    @required this.inProgress,
  });
}

enum PublishAction {
  portfolio,
  customersPortfolio,
  backstage,
  delete,
}

enum EditImageListMode {
  normal,
  unsorted,
  trash,
}
