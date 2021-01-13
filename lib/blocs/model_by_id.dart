import 'dart:async';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';
import 'model_cache.dart';

class ModelByIdBloc<I, O extends WithId<I>> extends Bloc {
  final ModelCacheBloc<I, O> _modelCacheBloc;
  final initialState = ModelByIdState<I, O>(id: null, object: null, requestStatus: RequestStatus.notTried);

  I _currentId; // Nullable
  ModelByIdState<I, O> _state = ModelByIdState<I, O>(id: null, object: null, requestStatus: RequestStatus.notTried);
  //O _currentObject; // Nullable

  final _inSetIdController = StreamController<I>();
  Sink<I> get inSetId => _inSetIdController.sink;

  final _outStateController = BehaviorSubject<ModelByIdState<I, O>>();
  Stream<ModelByIdState<I, O>> get outState => _outStateController.stream;

  ModelByIdBloc({
    @required ModelCacheBloc<I, O> modelCacheBloc,
  }) : _modelCacheBloc = modelCacheBloc {
    _inSetIdController.stream.listen(_handleSetId);
    _modelCacheBloc.outObjectsByIds.listen(_handleLoadedAnythingNew);
  }

  void _handleSetId(I id) {
    if (id == _currentId) return;
    _setId(id);
  }

  void _setId(I id) {
    _currentId = id;
    _modelCacheBloc.inLoad.add(id);
    _state = ModelByIdState<I, O>(id: id, object: null, requestStatus: RequestStatus.loading);
    _pushOutput();
  }

  void _handleLoadedAnythingNew(Map<I, O> objectsByIds) {
    if (!objectsByIds.containsKey(_currentId)) {
      return; // Something else loaded, still waiting for our object.
    }

    final currentObject = objectsByIds[_currentId];

    if (_state.requestStatus == RequestStatus.loading || currentObject != _state.object) {
      // TODO: Change from instance comparison to properties comparison?
      _state = (currentObject == null)
          ? ModelByIdState<I, O>(id: _currentId, object: null, requestStatus: RequestStatus.error)
          : ModelByIdState<I, O>(id: _currentId, object: currentObject, requestStatus: RequestStatus.ok);

      _pushOutput();
    }
  }

  void _pushOutput() {
    _outStateController.sink.add(_state);
  }

  @override
  void dispose() {
    _inSetIdController.close();
    _outStateController.close();
  }
}

class ModelByIdState<I, O extends WithId<I>> {
  final I id; // Nullable.
  final O object; // Nullable.
  final RequestStatus requestStatus;

  ModelByIdState({
    @required this.id,
    @required this.object,
    @required this.requestStatus,
  });
}
