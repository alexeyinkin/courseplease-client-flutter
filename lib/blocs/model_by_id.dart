import 'dart:async';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';
import 'model_cache.dart';

class ModelByIdBloc<I, O extends WithId<I>> extends Bloc {
  final ModelCacheBloc<I, O> _modelCacheBloc;
  final initialState = ModelByIdState<I, O>(id: null, object: null, requestStatus: RequestStatus.notTried);

  var _allObjectsByIds = Map<I, O>();
  I? _currentId;
  ModelByIdState<I, O> _state = ModelByIdState<I, O>(id: null, object: null, requestStatus: RequestStatus.notTried);

  final _outStateController = BehaviorSubject<ModelByIdState<I, O>>();
  Stream<ModelByIdState<I, O>> get outState => _outStateController.stream;

  ModelByIdBloc({
    required ModelCacheBloc<I, O> modelCacheBloc,
  }) : _modelCacheBloc = modelCacheBloc {
    _modelCacheBloc.states.listen(_handleLoadedAnythingNew);
  }

  void setCurrentId(I? id) {
    if (id == _currentId) return;

    _currentId = id;

    if (id != null) {
      _modelCacheBloc.loadByIdIfNot(id);
    }

    _updateState();
    _pushOutput();
  }

  void _updateState() {
    _state = _createState();
  }

  ModelByIdState<I, O> _createState() {
    if (_currentId == null) {
      return ModelByIdState<I, O>(id: null, object: null, requestStatus: RequestStatus.notTried);
    }

    if (!_allObjectsByIds.containsKey(_currentId)) {
      return ModelByIdState(id: _currentId, object: null, requestStatus: RequestStatus.loading);
    }

    final object = _allObjectsByIds[_currentId];

    if (object == null) {
      return ModelByIdState(id: _currentId, object: null, requestStatus: RequestStatus.error);
    }

    return ModelByIdState(id: _currentId, object: object, requestStatus: RequestStatus.ok);
  }

  void _handleLoadedAnythingNew(ModelCacheState<I, O> state) {
    _allObjectsByIds = state.objectsByIds;
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

class ModelByIdState<I, O extends WithId<I>> {
  final I? id;
  final O? object;
  final RequestStatus requestStatus;

  ModelByIdState({
    required this.id,
    required this.object,
    required this.requestStatus,
  });
}
