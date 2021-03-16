import 'dart:async';
import 'dart:collection';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class ModelCacheBloc<I, O extends WithId<I>> extends Bloc {
  final AbstractRepository<I, O> _repository;

  List<O> _allObjectsInOrder; // Unused?
  final _objectsByIds = Map<I, O>(); // O or Null.

  Future<List<O>> _allObjectsFuture; // Nullable.
  final _futuresByIds = Map<I, Future>(); // Future of object or list.

  final _outObjectsByIdsController = BehaviorSubject<Map<I, O>>();
  Stream<Map<I, O>> get outObjectsByIds => _outObjectsByIdsController.stream;

  ModelCacheBloc({
    @required AbstractRepository<I, O> repository,
  }) : _repository = repository {
    print('Creating ModelCacheBloc for ' + _typeOf<O>().toString());
  }

  void loadAllIfNot() {
    if (_allObjectsInOrder != null || _allObjectsFuture != null) return;
    loadAll();
  }

  void loadAll() {
    this._allObjectsFuture = _repository.loadAll();
    this._allObjectsFuture.then(_handleLoadedAll);
  }

  void _handleLoadedAll(List<O> objects) {
    _allObjectsInOrder = objects;
    _allObjectsFuture = null;
    _addSuccessfulObjects(objects);
    pushOutput();
  }

  void loadByIdIfNot(I id) {
    if (_objectsByIds.containsKey(id) || _futuresByIds.containsKey(id)) return;
    _loadById(id);
  }

  void _loadById(I id) {
    final future = _repository.loadById(id);
    _futuresByIds[id] = future;

    future.then(
      (object) => _handleLoaded([id], [object]),
      onError: (_, __) => _handleError([id]),
    );
  }

  void _handleLoaded(List<I> ids, List<O> objects) {
    _addSuccessfulObjects(objects);
    _addFailedObjects(_getMissingIds(ids));
    pushOutput();
  }

  void _addSuccessfulObjects(List<O> objects) {
    for (final object in objects) {
      addSuccessfulObject(object);
    }
  }

  @protected
  void addSuccessfulObject(O object) {
    _objectsByIds[object.id] = object;
    _futuresByIds.remove(object.id);
  }

  void _addFailedObjects(List<I> ids) {
    for (final id in ids) {
      _objectsByIds[id] = null;
      _futuresByIds.remove(id);
    }
  }

  void loadListIfNot(List<I> ids) {
    final idsToLoad = _getMissingIds(ids);
    if (idsToLoad.isEmpty) return;
    _loadList(idsToLoad);
  }

  void _loadList(List<I> ids) {
    final future = _repository.loadByIds(ids);

    for (final id in ids) {
      _futuresByIds[id] = future;
    }

    future.then(
      (objects) => _handleLoaded(ids, objects),
      onError: (_, __) => _handleError(ids),
    );
  }

  List<I> _getMissingIds(List<I> ids) {
    final result = <I>[];

    for (final id in ids) {
      if (_objectsByIds.containsKey(id) || _futuresByIds.containsKey(id)) continue;
      result.add(id);
    }

    return result;
  }

  @protected
  void pushOutput() {
    _outObjectsByIdsController.sink.add(UnmodifiableMapView<I, O>(_objectsByIds));
  }

  void _handleError(List<I> ids) {
    _addFailedObjects(ids);
    pushOutput();
  }

  @override
  void dispose() {
    _outObjectsByIdsController.close();
  }

  Type _typeOf<T>() => T;
}
