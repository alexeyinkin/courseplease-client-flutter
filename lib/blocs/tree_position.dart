import 'dart:async';
import 'dart:collection';

import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:courseplease/models/breadcrumbs.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class TreePositionBloc<
  I,
  O extends WithIdChildrenParent<I, O, O>
> implements Bloc {
  // TODO: Start at root when the root screen is developed.
  late I _currentId;
  late I _lastId;
  var _modelsByIds = Map<I, O>();

  late final ModelWithChildrenCacheBloc<I, O> _modelCacheBloc;
  late final StreamSubscription _productSubjectCacheBlocSubscription;

  final _outCurrentIdController = BehaviorSubject<I>();
  Stream<I> get outCurrentId => _outCurrentIdController.stream;

  final _outBreadcrumbsController = BehaviorSubject<Breadcrumbs<O>>();
  Stream<Breadcrumbs<O>> get outBreadcrumbs => _outBreadcrumbsController.stream;

  final _outChildrenController = BehaviorSubject<List<O>>();
  Stream<List<O>> get outChildren => _outChildrenController.stream;

  TreePositionBloc({
    required ModelWithChildrenCacheBloc<I, O> modelCacheBloc,
    required I currentId,
  }) :
      _currentId = currentId,
      _lastId = currentId,
      _modelCacheBloc = modelCacheBloc
  {
    _productSubjectCacheBlocSubscription = _modelCacheBloc.outObjectsByIds.listen(_setModelsByIds);
  }

  void _setModelsByIds(Map<I, O> map) {
    _modelsByIds = map;
    _pushOutput();
  }

  void setCurrentId(I id) {
    if (_currentId == id) return;
    _currentId = id;

    if (!_isDescendant(_currentId, _lastId)) {
      _lastId = _currentId;
    }

    _pushOutput();
  }

  void _pushOutput() {
    if (_currentId != null) {
      _outCurrentIdController.sink.add(_currentId);
      _pushBreadcrumbs();
      _pushChildren();
    }
  }

  void _pushBreadcrumbs() {
    final chain = <Breadcrumb<O>>[];
    var item = _modelsByIds[_lastId];

    while (item != null && item.id != _currentId) {
      chain.insert(
        0,
        Breadcrumb<O>(item: item, status: BreadcrumbStatus.descendant),
      );
      item = item.parent;
    }

    item = _modelsByIds[_currentId];
    if (item != null) {
      chain.insert(
        0,
        Breadcrumb<O>(item: item, status: BreadcrumbStatus.current),
      );
      item = item.parent;
    }

    while (item != null) {
      chain.insert(
        0,
        Breadcrumb<O>(item: item, status: BreadcrumbStatus.ancestor),
      );
      item = item.parent;
    }

    _outBreadcrumbsController.sink.add(
      Breadcrumbs<O>(
        list: UnmodifiableListView(chain),
      ),
    );
  }

  void _pushChildren() {
    var item = _modelsByIds[_currentId];
    _outChildrenController.sink.add(
        UnmodifiableListView(item == null ? <O>[] : item.children)
    );
  }

  bool _isDescendant(I ancestorId, I descendantId) {
    O? item = _modelsByIds[descendantId];

    while (item != null) {
      if (item.id == ancestorId) return true;
      item = item.parent;
    }

    return false;
  }

  @override
  void dispose() {
    _productSubjectCacheBlocSubscription.cancel();
    _outChildrenController.close();
    _outBreadcrumbsController.close();
    _outCurrentIdController.close();
  }
}
