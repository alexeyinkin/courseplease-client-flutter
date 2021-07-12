import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/utils/sort.dart';
import 'package:rxdart/rxdart.dart';

class SortedModelCacheBloc<I, O extends WithIdTitle<I>> implements ModelCacheBloc<I, O> {
  final _objectsByIdsController = BehaviorSubject<Map<I, O>>();
  @override
  Stream<Map<I, O>> get objectsByIds => _objectsByIdsController.stream;

  final _statesController = BehaviorSubject<ModelCacheState<I, O>>();
  @override
  Stream<ModelCacheState<I, O>> get states => _statesController.stream;

  final ModelCacheBloc<I, O> modelCacheBloc;

  SortedModelCacheBloc({
    required this.modelCacheBloc,
  }) {
    modelCacheBloc.states.listen(_onStateChanged);
  }

  void _onStateChanged(ModelCacheState<I, O> state) {
    final objects = state.objectsByIds.values.toList();
    objects.sort(Sorters.titleAsc);

    final objectsByIds = <I, O>{};
    for (final obj in objects) {
      objectsByIds[obj.id] = obj;
    }

    _statesController.sink.add(
      ModelCacheState<I, O>(
        objectsByIds: objectsByIds,
        triedIds: state.triedIds,
        failedIds: state.failedIds,
      ),
    );

    _objectsByIdsController.sink.add(objectsByIds);
  }

  @override
  void dispose() {
    _objectsByIdsController.close();
    _statesController.close();
  }

  @override
  void addSuccessfulObject(O object) => modelCacheBloc.addSuccessfulObject(object);

  @override
  O? getObjectById(I id) => modelCacheBloc.getObjectById(id);

  @override
  void loadAll() => modelCacheBloc.loadAll();

  @override
  void loadAllIfNot() => modelCacheBloc.loadAllIfNot();

  @override
  void loadByIdIfNot(I id) => modelCacheBloc.loadByIdIfNot(id);

  @override
  void loadListIfNot(List<I> ids) => modelCacheBloc.loadListIfNot(ids);

  @override
  void pushOutput() => modelCacheBloc.pushOutput();

  @override
  void removeId(I id) => modelCacheBloc.removeId(id);
}
