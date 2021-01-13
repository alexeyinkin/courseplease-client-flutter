import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:get_it/get_it.dart';

class FilteredModelListFactory {
  final _map = Map<Type, Map<AbstractFilter, FilteredModelListBloc>>();

  FilteredModelListBloc<I, O, F> getOrCreate<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >(F filter) {
    final type = _typeOf<O>();

    if (!_map.containsKey(type)) {
      _map[type] = Map<AbstractFilter, FilteredModelListBloc<I, O, F>>();
    }

    if (!_map[type].containsKey(filter)) {
      final repository = GetIt.instance.get<R>();
      _map[type][filter] = FilteredModelListBloc<I, O, F>(
        repository: repository,
        filter: filter,
      );
    }

    return _map[type][filter];
  }

  Type _typeOf<T>() => T;
}
