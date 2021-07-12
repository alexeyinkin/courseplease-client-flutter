import 'dart:async';
import 'dart:collection';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class ModelCacheBloc<I, O extends WithId<I>> extends Bloc {
  final AbstractRepository<I, O> _repository;

  final _objectsByIds = Map<I, O>();
  final _triedIds = Map<I, void>();
  final _failedIds = Map<I, void>();
  bool _triedAll = false;

  final _objectsByIdsController = BehaviorSubject<Map<I, O>>();
  Stream<Map<I, O>> get objectsByIds => _objectsByIdsController.stream;

  final _statesController = BehaviorSubject<ModelCacheState<I, O>>();
  Stream<ModelCacheState<I, O>> get states => _statesController.stream;

  ModelCacheBloc({
    required AbstractRepository<I, O> repository,
  }) : _repository = repository {
    print('Creating ModelCacheBloc for ' + _typeOf<O>().toString());
  }

  void loadAllIfNot() {
    if (_triedAll) return;
    loadAll();
  }

  void loadAll() async {
    _triedAll = true;

    final all = await _repository.loadAll();
    _addSuccessfulObjects(all);
    pushOutput();
  }

  void loadByIdIfNot(I id) {
    if (_triedAll || _triedIds.containsKey(id)) return;
    _loadById(id);
  }

  void _loadById(I id) async {
    _triedIds[id] = true;

    final object = await _repository.loadById(id);

    if (object == null) {
      _addFailedObject(id);
    } else {
      addSuccessfulObject(object);
    }
    pushOutput();
  }

  void _handleLoaded(List<I> ids, List<O> objects) {
    _addSuccessfulObjects(objects);
    _addFailedObjects(_getNotLoadedIds(ids));
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
  }

  void _addFailedObjects(List<I> ids) {
    for (final id in ids) {
      _addFailedObject(id);
    }
  }

  void _addFailedObject(I id) {
    _failedIds[id] = true;
  }

  void loadListIfNot(List<I> ids) {
    final idsToLoad = _getNotTriedIds(ids);
    if (idsToLoad.isEmpty) return;
    _loadList(idsToLoad);
  }

  void _loadList(List<I> ids) async {
    final objects = await _repository.loadByIds(ids);
    _handleLoaded(ids, objects);
  }

  List<I> _getNotTriedIds(List<I> ids) {
    if (_triedAll) return [];

    final result = <I>[];
    for (final id in ids) {
      if (_triedIds.containsKey(id)) continue;
      result.add(id);
    }
    return result;
  }

  List<I> _getNotLoadedIds(List<I> ids) {
    final result = <I>[];
    for (final id in ids) {
      if (_objectsByIds.containsKey(id)) continue;
      result.add(id);
    }
    return result;
  }

  O? getObjectById(I id) {
    return _objectsByIds[id];
  }

  void removeId(I id) {
    _objectsByIds.remove(id);
    _triedIds.remove(id);
    _failedIds.remove(id);
    pushOutput();
  }

  @protected
  void pushOutput() {
    _objectsByIdsController.sink.add(UnmodifiableMapView<I, O>(_objectsByIds));
    _statesController.sink.add(_createState());
  }

  ModelCacheState<I, O> _createState() {
    return ModelCacheState<I, O>(
      objectsByIds: _objectsByIds,
      triedIds: _triedIds,
      failedIds: _failedIds,
    );
  }

  @override
  void dispose() {
    _statesController.close();
    _objectsByIdsController.close();
  }

  Type _typeOf<T>() => T;
}

class ModelCacheState<I, O extends WithId<I>> {
  final Map<I, O> objectsByIds;
  final Map<I, void> triedIds;
  final Map<I, void> failedIds;

  ModelCacheState({
    required this.objectsByIds,
    required this.triedIds,
    required this.failedIds,
  });
}
