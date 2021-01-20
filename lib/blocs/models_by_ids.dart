import 'dart:async';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

import 'bloc.dart';
import 'model_cache.dart';

class ModelListByIdsBloc<I, O extends WithId<I>> extends Bloc {
  final ModelCacheBloc<I, O> _modelCacheBloc;
  final initialState = ModelListByIdsState<O>(objects: <O>[], requestStatus: RequestStatus.notTried);

  var _allObjectsByIds = Map<I, O>();
  var _currentIds = <I>[];
  ModelListByIdsState<O> _state = ModelListByIdsState<O>(objects: <O>[], requestStatus: RequestStatus.notTried);

  final _outStateController = BehaviorSubject<ModelListByIdsState<O>>();
  Stream<ModelListByIdsState<O>> get outState => _outStateController.stream;

  ModelListByIdsBloc({
    @required ModelCacheBloc<I, O> modelCacheBloc,
  }) : _modelCacheBloc = modelCacheBloc {
    _modelCacheBloc.outObjectsByIds.listen(_handleLoadedAnythingNew);
  }

  void setCurrentIds(List<I> ids) {
    if (ListEquality().equals(ids, _currentIds)) return;

    _currentIds = ids;
    _modelCacheBloc.loadListIfNot(ids);
    _updateState();
    _pushOutput();
  }

  void _updateState() {
    _state = _createState();
  }

  ModelListByIdsState<O> _createState() {
    if (_currentIds.isEmpty) {
      return ModelListByIdsState<O>(objects: <O>[], requestStatus: RequestStatus.ok);
    }

    final objects = <O>[];
    bool complete = true;

    for (final id in _currentIds) {
      if (!_allObjectsByIds.containsKey(id)) {
        complete = false;
      } else {
        objects.add(_allObjectsByIds[id]);
      }
    }

    return complete
        ? ModelListByIdsState(objects: objects, requestStatus: RequestStatus.ok)
        : ModelListByIdsState(objects: objects, requestStatus: RequestStatus.loading);
  }

  void _handleLoadedAnythingNew(Map<I, O> objectsByIds) {
    _allObjectsByIds = objectsByIds;
    _updateState();
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(_state);
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
    @required this.objects,
    @required this.requestStatus,
  });
}
