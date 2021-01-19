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
  RequestStatus _status = RequestStatus.ok;
  bool _hasMore = true;

  Future<void> _currentLoadingFuture; // Nullable.
  String _nextPageToken = null;

  final _inEventsController = StreamController<AbstractModelListEvent>();
  Sink<AbstractModelListEvent> get inEvents => _inEventsController.sink;

  final _outStateController = BehaviorSubject<ModelListState>();
  Stream<ModelListState> get outState => _outStateController.stream;

  final initialState = ModelListState<O>(
    objects:  <O>[],
    status:   RequestStatus.ok,
    hasMore:  true,
  );

  // String _nextPageToken = null;
  // bool more = true;

  FilteredModelListBloc({
    @required this.repository,
    @required this.filter,
  }) {
    _inEventsController.stream.listen((event) => _handleEvent(event));
    //inLoadMore.add(null);
  }

  void _handleEvent(AbstractModelListEvent event) {
    if (event is LoadMoreEvent) {
      _handleLoadMore();
    } else if (event is LoadInitialIfNotEvent) {
      if (_objects.length == 0) {
        _handleLoadMore();
      }
    }
  }

  void _handleLoadMore() {
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

  // Future<void> loadMore() {
  //   if (_currentLoadingFuture != null) return _currentLoadingFuture;
  //
  //   _currentLoadingFuture = repository
  //       .loadWithFilter(filter, _nextPageToken)
  //       .then((loadResult) => _handleLoaded(loadResult));
  //   return _currentLoadingFuture;
  // }

  // Future<O> getAt(int index) {
  //   if (index < 0) {
  //     throw new Exception('Index should be >= 0.');
  //   }
  //
  //   if (index < objects.length) {
  //     return Future.value(objects[index]);
  //   }
  //
  //   if (!more) {
  //     throw new Exception('No more here.');
  //   }
  //
  //   print('Called getAt(' + index.toString() + ')');
  //   return loadMore().then((result) => getAt(index));
  // }

  void _handleLoaded(ListLoadResult<O> loadResult) {
    _objects.addAll(loadResult.objects);
    print('Added to list, now got ' + _objects.length.toString() + ' objects.');

    _status               = RequestStatus.ok;
    _hasMore              = loadResult.hasMore();
    _nextPageToken        = loadResult.nextPageToken;
    _currentLoadingFuture = null;

    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      ModelListState<O>(
        objects:  _objects,
        status:   RequestStatus.ok,
        hasMore:  _hasMore,
      ),
    );
  }

  void _handleError(_, StackTrace trace) {
    _status = RequestStatus.error;
    _pushOutput();
  }

  @override
  void dispose() {
    _inEventsController.close();
    _outStateController.close();
  }
}

class ModelListState<O extends WithId> {
  final List<O> objects;
  final RequestStatus status;
  final bool hasMore;

  ModelListState({
    @required this.objects,
    @required this.status,
    @required this.hasMore,
  });
}

abstract class AbstractModelListEvent {
  const AbstractModelListEvent();
}

class LoadInitialIfNotEvent extends AbstractModelListEvent {
  const LoadInitialIfNotEvent();
}

class LoadMoreEvent extends AbstractModelListEvent {
  const LoadMoreEvent();
}
