import 'dart:async';

import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:model_interfaces/model_interfaces.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class TreePositionBloc<
  I,
  O extends WithIdChildrenParent<I, O, O>
> implements Bloc {
  I? _currentId;
  I? _lastId;
  var _topLevelModels = <O>[];
  var _modelsByIds = Map<I, O>();

  final ModelWithChildrenCacheBloc<I, O> _modelCacheBloc;
  late final StreamSubscription _productSubjectCacheBlocSubscription;

  final _statesController = BehaviorSubject<TreePositionState<I, O>>();
  Stream<TreePositionState<I, O>> get states => _statesController.stream;

  late final TreePositionState<I, O> initialState;
  TreePositionState<I, O> get state => _createState();

  TreePositionBloc({
    required ModelWithChildrenCacheBloc<I, O> modelCacheBloc,
    I? currentId,
  }) :
      _currentId = currentId,
      _lastId = currentId,
      _modelCacheBloc = modelCacheBloc
  {
    initialState = _createState();
    _modelCacheBloc.outTopLevelObjects.listen(_setTopLevelModels);
    _productSubjectCacheBlocSubscription = _modelCacheBloc.objectsByIds.listen(_setModelsByIds);
  }

  void _setTopLevelModels(List<O> list) {
    _topLevelModels = list;
    _pushOutput();
  }

  void _setModelsByIds(Map<I, O> map) {
    _modelsByIds = map;
    _pushOutput();
  }

  /// Walks one step up if possible. Has no effect if the current item is null.
  void up() {
    final parent = _getCurrentItem()?.parent;
    setCurrentId(parent?.id);
  }

  void setCurrentId(I? id) {
    if (_currentId == id) return;
    _currentId = id;

    if (!_isDescendant(_currentId, _lastId)) {
      _lastId = _currentId;
    }

    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  TreePositionState<I, O> _createState() {
    return TreePositionState<I, O>(
      currentId:              _currentId,
      ancestorBreadcrumbs:    _getAncestorBreadcrumbs(),
      currentObject:          _getCurrentItem(),
      descendantBreadcrumbs:  _getDescendantBreadcrumbs(),
      currentChildren:        _getCurrentChildren(),
    );
  }

  List<O> _getAncestorBreadcrumbs() {
    final result = <O>[];
    var item = _getCurrentItem()?.parent;

    while (item != null) {
      result.insert(0, item);
      item = item.parent;
    }

    return result;
  }

  List<O> _getDescendantBreadcrumbs() {
    final result = <O>[];
    var item = _getCurrentItem();

    while (item != null && item.id != _currentId) {
      result.insert(0, item);
      item = item.parent;
    }

    return result;
  }

  List<O> _getCurrentChildren() {
    final item = _getCurrentItem();
    return item == null ? _topLevelModels : item.children;
  }

  bool _isDescendant(I? ancestorId, I? descendantId) {
    if (ancestorId == null) return true;
    if (descendantId == null) return false;

    O? item = _modelsByIds[descendantId];

    while (item != null) {
      if (item.id == ancestorId) return true;
      item = item.parent;
    }

    return false;
  }

  O? _getCurrentItem() => _modelsByIds[_currentId];

  @override
  void dispose() {
    _statesController.close();
    _productSubjectCacheBlocSubscription.cancel();
  }
}

class TreePositionState<
  I,
  O extends WithIdChildrenParent<I, O, O>
> {
  final I? currentId;
  final List<O> ancestorBreadcrumbs;
  final O? currentObject;
  final List<O> descendantBreadcrumbs;
  final List<O> currentChildren;

  TreePositionState({
    required this.currentId,
    required this.ancestorBreadcrumbs,
    required this.currentObject,
    required this.descendantBreadcrumbs,
    required this.currentChildren,
  });
}
