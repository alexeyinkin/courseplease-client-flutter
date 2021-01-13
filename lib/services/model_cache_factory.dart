import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:get_it/get_it.dart';

class ModelCacheFactory {
  final _map = Map<Type, ModelCacheBloc>();

  ModelCacheBloc<I, O> getOrCreate<
    I,
    O extends WithId<I>,
    R extends AbstractRepository<I, O>
  >() {
    final type = _typeOf<O>();

    if (!_map.containsKey(type)) {
      final repository = GetIt.instance.get<R>();
      _map[type] = ModelCacheBloc<I, O>(
        repository: repository,
      );
    }

    return _map[type];
  }

  ModelWithChildrenCacheBloc<I, O> getOrCreateWithChildren<
    I,
    O extends WithIdChildren<I, O>,
    R extends AbstractRepository<I, O>
  >() {
    final type = _typeOf<O>();

    if (!_map.containsKey(type)) {
      final repository = GetIt.instance.get<R>();
      _map[type] = ModelWithChildrenCacheBloc<I, O>(
        repository: repository,
      );
    }

    return _map[type];
  }

  Type _typeOf<T>() => T;
}
