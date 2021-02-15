import 'dart:collection';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:get_it/get_it.dart';

class FilteredModelListCache {
  final _factory = FilteredModelListFactory();
  final _map = Map<Type, Map<Type, Map<String, FilteredModelListBloc>>>();
  //               ^Object   ^Filter   ^Filter
  //                type      type      toString

  FilteredModelListBloc<I, O, F> getOrCreate<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    final objectType = _typeOf<O>();
    final filterType = _typeOf<F>();
    final filterString = filter.toString();

    if (!_map.containsKey(objectType)) {
      _map[objectType] = Map<Type, Map<String, FilteredModelListBloc>>();
    }

    if (!_map[objectType].containsKey(filterType)) {
      _map[objectType][filterType] = Map<String, FilteredModelListBloc<I, O, F>>();
    }

    if (!_map[objectType][filterType].containsKey(filterString)) {
      _map[objectType][filterType][filterString] = _factory.create<I, O, F, R>(filter);
    }

    return _map[objectType][filterType][filterString];
  }

  Map<String, FilteredModelListBloc> getModelListsByObjectAndFilterTypes<O, F>() {
    final objectType = _typeOf<O>();
    final filterType = _typeOf<F>();

    return UnmodifiableMapView<String, FilteredModelListBloc>(_map[objectType][filterType]);
  }

  Type _typeOf<T>() => T;
}

class FilteredModelListFactory {
  FilteredModelListBloc<I, O, F> create<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    final repository = GetIt.instance.get<R>();
    return FilteredModelListBloc<I, O, F>(
      repository: repository,
      filter: filter,
    );
  }
}
