import 'dart:async';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';
import 'model_cache.dart';

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
  final ModelCacheBloc<I, O> cache;
  final ModelListByIdsBloc<I, O> _listBloc;

  final _ids = <I>[];
  late ModelListByIdsState<I, O> _lastListState;

  RequestStatus _status = RequestStatus.notTried;
  bool _hasMore = true;

  Future<void>? _currentLoadingFuture;
  String? _nextPageToken;

  NetworkFilteredModelListBloc({
    required this.repository,
    required this.cache,
    required F filter,
  }) :
      _listBloc = ModelListByIdsBloc<I, O>(modelCacheBloc: cache),
      super(
        filter: filter,
      )
  {
    _lastListState = _listBloc.initialState;
    _listBloc.outState.listen(_onListStateChanged);
  }

  void _onListStateChanged(ModelListByIdsState<I, O> state) {
    _lastListState = state;
    _pushOutput();
  }

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
    cache.addAll(loadResult.objects);
    _ids.addAll(getIds(loadResult.objects));
    _listBloc.setCurrentIds(_ids);

    print('Added to list, now got ' + _ids.length.toString() + ' objects.');

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
        objects:      _lastListState.objects,
        objectIds:    _lastListState.objectsByIds.keys.toList(growable: false),
        objectsByIds: _lastListState.objectsByIds,
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
    return _lastListState.objectsByIds[id];
  }

  void removeObjectIds(List<I> ids) {
    if (ids.isEmpty) return;

    final idsMap = Map<I, I>.fromIterable(ids, key: (id) => id, value: (id) => id);

    _ids.removeWhere((I id) => idsMap.containsKey(id));
    _listBloc.setCurrentIds(_ids);
  }

  bool containsId(I id) {
    return _lastListState.objectsByIds.containsKey(id);
  }

  void addToBeginning(List<O> objects) {
    if (objects.isEmpty) return;

    cache.addAll(objects);
    _ids.insertAll(0, getIds(objects));
    _listBloc.setCurrentIds(_ids);
  }

  void addToEnd(List<O> objects) {
    if (objects.isEmpty) return;

    cache.addAll(objects);
    _ids.addAll(getIds(objects));
    _listBloc.setCurrentIds(_ids);
  }

  void replaceIfExist(List<O> objects) {
    cache.addAll(objects);
  }

  void onExternalObjectChange() {
    _pushOutput();
  }

  void clear() {
    _ids.clear();
    _lastListState = _listBloc.initialState;
    _status = RequestStatus.notTried;
    _hasMore = true;
    _currentLoadingFuture = null;
    _nextPageToken = null;
    _pushOutput();
  }

  void clearAndLoadFirstPage() {
    _ids.clear();
    _lastListState = _listBloc.initialState;
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

// TODO: Use ModelCacheBloc as the direct backing to this list.
//       Now using a NetworkFilteredModelListBloc because it was not backed
//       by ModelCacheBloc initially.
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
