import 'dart:async';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class FilteredModelListBloc<I, O extends WithId<I>, F extends AbstractFilter> extends Bloc {
  final AbstractFilteredRepository<I, O, F> repository;
  final F filter;

  final _objects = <O>[];
  final _objectIds = <I>[];
  RequestStatus _status = RequestStatus.ok;
  bool _hasMore = true;

  Future<void> _currentLoadingFuture; // Nullable.
  String _nextPageToken = null;

  final _outStateController = BehaviorSubject<ModelListState<I, O>>();
  Stream<ModelListState<I, O>> get outState => _outStateController.stream;

  final initialState = ModelListState<I, O>(
    objects:    <O>[],
    objectIds:  <I>[],
    status:     RequestStatus.ok,
    hasMore:    true,
  );

  FilteredModelListBloc({
    @required this.repository,
    @required this.filter,
  });

  void loadInitialIfNot() {
    if (_objects.length == 0) {
      loadMoreIfCan();
    }
  }

  void loadMoreIfCan() {
    if (!_hasMore || _status == RequestStatus.loading) return;
    _loadMore();
  }

  void _loadMore() {
    _currentLoadingFuture = repository
        .loadWithFilter(filter, _nextPageToken)
        .then(
          (loadResult) => _handleLoaded(loadResult),
          onError: _handleError,
        );

    _status = RequestStatus.loading;
    _pushOutput();
  }

  void _handleLoaded(ListLoadResult<O> loadResult) {
    _objects.addAll(loadResult.objects);

    for (final object in loadResult.objects) {
      _objectIds.add(object.id);
    }
    print('Added to list, now got ' + _objects.length.toString() + ' objects.');

    _status               = RequestStatus.ok;
    _hasMore              = loadResult.hasMore();
    _nextPageToken        = loadResult.nextPageToken;
    _currentLoadingFuture = null;

    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      ModelListState<I, O>(
        objects:    _objects,
        objectIds:  _objectIds,
        status:     RequestStatus.ok,
        hasMore:    _hasMore,
      ),
    );
  }

  void _handleError(_, StackTrace trace) {
    _status = RequestStatus.error;
    _pushOutput();
  }

  void removeObjectIds(List<I> ids) {
    final idsMap = Map<I, I>.fromIterable(ids, key: (id) => id, value: (id) => id);
    var changed = false;

    for (var i = _objectIds.length; --i >= 0; ) {
      final id = _objectIds[i];
      if (idsMap.containsKey(id)) {
        _objects.removeAt(i);
        _objectIds.removeAt(i);
        changed = true;
      }
    }

    if (changed) {
      _pushOutput();
    }
  }

  void clearAndLoadFirstPage() {
    _objects.clear();
    _objectIds.clear();
    _status = RequestStatus.ok;
    _hasMore = true;
    _currentLoadingFuture = null;
    _nextPageToken = null;
    //_pushOutput();
    _loadMore();
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class ModelListState<I, O extends WithId<I>> {
  final List<O> objects;
  final List<I> objectIds;
  final RequestStatus status;
  final bool hasMore;

  ModelListState({
    @required this.objects,
    @required this.objectIds,
    @required this.status,
    @required this.hasMore,
  });
}
