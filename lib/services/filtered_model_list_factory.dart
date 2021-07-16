import 'dart:collection';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

class FilteredModelListCache {
  final _factory = FilteredModelListFactory();
  final _networkLists = Map<Type, Map<Type, Map<String, NetworkFilteredModelListBloc>>>();
  //                        ^Object   ^Filter   ^Filter
  //                         type      type      toString

  final _subsetLists = Map<Type, Map<String, SubsetFilteredModelListBloc>>();
  //                       ^Object   ^Filter
  //                        type     toString

  AbstractFilteredModelListBloc<I, O, F> getOrCreate<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    if (filter is IdsSubsetFilter<I, O>) {
      return _getOrCreateSubsetList<I, O>(filter) as AbstractFilteredModelListBloc<I, O, F>;
    }

    return getOrCreateNetworkList<I, O, F, R>(filter);
  }

  NetworkFilteredModelListBloc<I, O, F> getOrCreateNetworkList<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    final objectType = typeOf<O>();
    final filterType = typeOf<F>();
    final filterString = filter.toString();

    if (!_networkLists.containsKey(objectType)) {
      _networkLists[objectType] = Map<Type, Map<String, NetworkFilteredModelListBloc>>();
    }

    if (!_networkLists[objectType]!.containsKey(filterType)) {
      _networkLists[objectType]![filterType] = Map<String, NetworkFilteredModelListBloc<I, O, F>>();
    }

    if (!_networkLists[objectType]![filterType]!.containsKey(filterString)) {
      _networkLists[objectType]![filterType]![filterString] = _factory.createNetworkList<I, O, F, R>(filter);
    }

    return _networkLists[objectType]![filterType]![filterString] as NetworkFilteredModelListBloc<I, O, F>;
  }

  SubsetFilteredModelListBloc<I, O> _getOrCreateSubsetList<
    I,
    O extends WithId<I>
  >(IdsSubsetFilter<I, O> filter) {
    final objectType = typeOf<O>();
    final filterString = filter.toString();

    if (!_subsetLists.containsKey(objectType)) {
      _subsetLists[objectType] = Map<String, SubsetFilteredModelListBloc>();
    }

    if (!_subsetLists[objectType]!.containsKey(filterString)) {
      _subsetLists[objectType]![filterString] = _factory.createSubsetList<I, O>(filter);
    }

    return _subsetLists[objectType]![filterString] as SubsetFilteredModelListBloc<I, O>;
  }

  Map<Type, Map<String, NetworkFilteredModelListBloc>> getNetworkModelListsByObjectType<O>() {
    final objectType = typeOf<O>();
    return UnmodifiableMapView<Type, Map<String, NetworkFilteredModelListBloc>>(
      _networkLists[objectType] ?? {},
    );
  }

  Map<String, NetworkFilteredModelListBloc<I, O, F>> getModelListsByObjectAndFilterTypes<I, O extends WithId<I>, F extends AbstractFilter>() {
    final objectType = typeOf<O>();
    final filterType = typeOf<F>();
    final map = (
          _networkLists[objectType]?[filterType]
          as Map<String, NetworkFilteredModelListBloc<I, O, F>>?
        )
        ?? <String, NetworkFilteredModelListBloc<I, O, F>>{};

    return UnmodifiableMapView<String, NetworkFilteredModelListBloc<I, O, F>>(map);
  }
}

class FilteredModelListFactory {
  NetworkFilteredModelListBloc<I, O, F> createNetworkList<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    final repository = GetIt.instance.get<R>();
    final cache = GetIt.instance.get<ModelCacheCache>().getOrCreate<I, O, R>();

    return NetworkFilteredModelListBloc<I, O, F>(
      repository: repository,
      cache: cache,
      filter: filter,
    );
  }

  SubsetFilteredModelListBloc<I, O> createSubsetList<
    I,
    O extends WithId<I>
  >(IdsSubsetFilter<I, O> filter) {
    return SubsetFilteredModelListBloc<I, O>(
      filter: filter,
    );
  }
}
