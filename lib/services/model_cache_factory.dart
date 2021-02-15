import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:get_it/get_it.dart';

class ModelCacheCache {
  final _factory = ModelCacheFactory();
  final _map = Map<Type, ModelCacheBloc>();

  ModelCacheBloc<I, O> getOrCreate<
    I,
    O extends WithId<I>,
    R extends AbstractRepository<I, O>
  >() {
    final type = _typeOf<O>();

    if (!_map.containsKey(type)) {
      _map[type] = _factory.create<I, O, R>();
    }

    return _map[type];
  }

  ModelWithChildrenCacheBloc<I, O> getOrCreateWithChildren<
    I,
    O extends WithIdChildrenParent<I, O, O>,
    R extends AbstractRepository<I, O>
  >() {
    final type = _typeOf<O>();

    if (!_map.containsKey(type)) {
      _map[type] = _factory.createWithChildren<I, O, R>();
    }

    return _map[type];
  }

  Type _typeOf<T>() => T;
}

class ModelCacheFactory {
  ModelCacheBloc<I, O> create<
    I,
    O extends WithId<I>,
    R extends AbstractRepository<I, O>
  >() {
    final repository = GetIt.instance.get<R>();
    return ModelCacheBloc<I, O>(
      repository: repository,
    );
  }

  ModelWithChildrenCacheBloc<I, O> createWithChildren<
    I,
    O extends WithIdChildrenParent<I, O, O>,
    R extends AbstractRepository<I, O>
  >() {
    final repository = GetIt.instance.get<R>();
    return ModelWithChildrenCacheBloc<I, O>(
      repository: repository,
    );
  }
}
