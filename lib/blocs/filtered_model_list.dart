import 'dart:async';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

abstract class AbstractFilteredModelListBloc<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> extends Bloc {
  final F filter;

  final _outStateController = BehaviorSubject<ModelListState<I, O>>();
  Stream<ModelListState<I, O>> get outState => _outStateController.stream;

  AbstractFilteredModelListBloc({
    required this.filter,
  });

  final initialState = ModelListState<I, O>(
    objects:      <O>[],
    objectIds:    <I>[],
    objectsByIds: Map<I, O>(),
    status:       RequestStatus.ok,
    hasMore:      true,
  );

  void loadInitialIfNot();
  void loadMoreIfCan();
  void loadAll();

  @override
  void dispose() {
    _outStateController.close();
  }
}

class NetworkFilteredModelListBloc<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> extends AbstractFilteredModelListBloc<I, O, F> {
  final AbstractFilteredRepository<I, O, F> repository;

  final _objects = <O>[];
  final _objectsByIds = Map<I, O>();
  RequestStatus _status = RequestStatus.notTried;
  bool _hasMore = true;

  Future<void>? _currentLoadingFuture;
  String? _nextPageToken;

  NetworkFilteredModelListBloc({
    required this.repository,
    required F filter,
  }) : super(
    filter: filter,
  );

  @override
  void loadInitialIfNot() {
    if (_status == RequestStatus.notTried) {
      loadMoreIfCan();
    }
  }

  @override
  void loadMoreIfCan() {
    if (!_hasMore || _status == RequestStatus.loading) return;
    _setLoadingAndLoadMore();
  }

  void _setLoadingAndLoadMore() {
    _status = RequestStatus.loading;
    _pushOutput();
    _loadMore();
  }

  void _loadMore() {
    if (_status == RequestStatus.error) {
      print('Cannot load more, last status was error.');
      return;
    }

    _currentLoadingFuture = repository
        .loadWithFilter(filter, _nextPageToken)
        .then(
          (loadResult) => _handleLoaded(loadResult),
          onError: _handleError,
        );
  }

  void _handleLoaded(ListLoadResult<O> loadResult) {
    _objects.addAll(loadResult.objects);

    for (final object in loadResult.objects) {
      _objectsByIds[object.id] = object;
    }
    print('Added to list, now got ' + _objects.length.toString() + ' objects.');

    _status               = RequestStatus.ok;
    _hasMore              = loadResult.hasMore();
    _nextPageToken        = loadResult.nextPageToken;
    _currentLoadingFuture = null;

    _pushOutput();
  }

  @override
  void loadAll() async {
    if (!_hasMore || _status == RequestStatus.loading) return;

    _loadMore();
    await _currentLoadingFuture;
    loadAll();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      ModelListState<I, O>(
        objects:      _objects,
        objectIds:    _objectsByIds.keys.toList(growable: false),
        objectsByIds: _objectsByIds,
        status:       _status,
        hasMore:      _hasMore,
      ),
    );
  }

  void _handleError(_, StackTrace trace) {
    _hasMore = false;
    _status = RequestStatus.error;
    _pushOutput();
  }

  O? getObject(I id) {
    return _objectsByIds[id];
  }

  void removeObjectIds(List<I> ids) {
    if (ids.isEmpty) return;

    final idsMap = Map<I, I>.fromIterable(ids, key: (id) => id, value: (id) => id);
    final lengthWas = _objects.length;

    _objects.removeWhere((O object) => idsMap.containsKey(object.id));
    for (final id in ids) {
      _objectsByIds.remove(id);
    }

    if (_objects.length < lengthWas) {
      _pushOutput();
    }
  }

  bool containsId(I id) {
    return _objectsByIds.containsKey(id);
  }

  void addToBeginning(List<O> objects) {
    if (objects.isEmpty) return;

    _objects.insertAll(0, objects);
    for (final object in objects) {
      _objectsByIds[object.id] = object;
    }

    _pushOutput();
  }

  void replaceIfExist(List<O> objects) {
    bool changed = false;

    for (final obj in objects) {
      if (!_objectsByIds.containsKey(obj.id)) continue;

      final index = _objects.indexWhere((old) => old.id == obj.id);
      _objects[index] = obj;
      _objectsByIds[obj.id] = obj;
      changed = true;
    }

    if (changed) _pushOutput();
  }

  void onExternalObjectChange() {
    _pushOutput();
  }

  void clear() {
    _objects.clear();
    _objectsByIds.clear();
    _status = RequestStatus.notTried;
    _hasMore = true;
    _currentLoadingFuture = null;
    _nextPageToken = null;
    _pushOutput();
  }

  void clearAndLoadFirstPage() {
    _objects.clear();
    _objectsByIds.clear();
    _status = RequestStatus.ok;
    _hasMore = true;
    _currentLoadingFuture = null;
    _nextPageToken = null;
    _loadMore();
  }
}

class ModelListState<I, O extends WithId<I>> {
  final List<O> objects;
  final List<I> objectIds;
  final Map<I, O> objectsByIds;
  final RequestStatus status;
  final bool hasMore;

  ModelListState({
    required this.objects,
    required this.objectIds,
    required this.objectsByIds,
    required this.status,
    required this.hasMore,
  });
}

class SubsetFilteredModelListBloc<
  I,
  O extends WithId<I>
> extends AbstractFilteredModelListBloc<I, O, IdsSubsetFilter<I, O>> {
  late StreamSubscription<ModelListState<I, O>> _nestedBlocSubscription;

  SubsetFilteredModelListBloc({
    required IdsSubsetFilter<I, O> filter,
  }) : super(
    filter: filter,
  ) {
    _nestedBlocSubscription = filter.nestedList.outState.listen(
      _onNestedBlocStateChanged
    );
  }

  void _onNestedBlocStateChanged(ModelListState<I, O> nestedState) {
    final objects = <O>[];
    final objectsByIds = Map<I, O>();

    for (final id in filter.ids) {
      final object = nestedState.objectsByIds[id];
      if (object == null) {
        continue; // TODO: Throw?
      }
      objects.add(object);
      objectsByIds[id] = object;
    }

    final state = ModelListState(
      objects:      objects,
      objectIds:    objectsByIds.keys.toList(growable: false),
      objectsByIds: objectsByIds,
      status:       nestedState.status,
      hasMore:      false,
    );

    _outStateController.sink.add(state);
  }

  @override
  void loadInitialIfNot() {
    // Nothing we can do about loading as the content is pushed from the nested bloc.
  }

  @override
  void loadMoreIfCan() {
    // Nothing we can do about loading as the content is pushed from the nested bloc.
  }

  @override
  void loadAll() {
    // Nothing we can do about loading as the content is pushed from the nested bloc.
  }

  @override
  void dispose() {
    _nestedBlocSubscription.cancel();
    super.dispose();
  }
}
