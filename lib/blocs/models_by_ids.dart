import 'dart:async';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

import 'bloc.dart';
import 'model_cache.dart';

class ModelListByIdsBloc<I, O extends WithId<I>> extends Bloc {
  final ModelCacheBloc<I, O> _modelCacheBloc;
  final initialState = ModelListByIdsState<O>(objects: <O>[], requestStatus: RequestStatus.notTried);

  var _currentIds = <I>[];
  ModelCacheState<I, O>? _cacheState;

  final _outStateController = BehaviorSubject<ModelListByIdsState<O>>();
  Stream<ModelListByIdsState<O>> get outState => _outStateController.stream;

  ModelListByIdsBloc({
    required ModelCacheBloc<I, O> modelCacheBloc,
  }) : _modelCacheBloc = modelCacheBloc {
    _modelCacheBloc.outState.listen(_handleLoadedAnythingNew);
  }

  void setCurrentIds(List<I> ids) {
    if (ListEquality().equals(ids, _currentIds)) return;

    _currentIds = ids;
    _modelCacheBloc.loadListIfNot(ids);
    _pushOutput();
  }

  ModelListByIdsState<O> _createState() {
    if (_currentIds.isEmpty) {
      return ModelListByIdsState<O>(objects: <O>[], requestStatus: RequestStatus.ok);
    }

    final cacheState = _cacheState;
    if (cacheState == null) {
      return ModelListByIdsState(objects: <O>[], requestStatus: RequestStatus.loading);
    }

    final objects = <O>[];
    bool complete = true;

    for (final id in _currentIds) {
      final object = cacheState.objectsByIds[id];

      if (object != null) {
        objects.add(object);
        continue;
      }

      if (!cacheState.failedIds.containsKey(id)) {
        complete = false;
      }
    }

    return complete
        ? ModelListByIdsState(objects: objects, requestStatus: RequestStatus.ok)
        : ModelListByIdsState(objects: objects, requestStatus: RequestStatus.loading);
  }

  void _handleLoadedAnythingNew(ModelCacheState<I, O> state) {
    _cacheState = state;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(_createState());
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class ModelListByIdsState<O extends WithId> {
  final List<O> objects;
  final RequestStatus requestStatus;

  ModelListByIdsState({
    required this.objects,
    required this.requestStatus,
  });
}
