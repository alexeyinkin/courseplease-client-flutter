import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

class ModelCacheCache {
  final _factory = ModelCacheFactory();
  final _map = Map<Type, Map<Type, ModelCacheBloc>>();

  ModelCacheBloc<I, O> getOrCreate<
    I,
    O extends WithId<I>,
    R extends AbstractRepository<I, O>
  >() {
    final objectType = _typeOf<O>();
    final repositoryType = _typeOf<R>();

    if (!_map.containsKey(objectType)) {
      _map[objectType] = <Type, ModelCacheBloc>{};
    }

    if (!_map[objectType]!.containsKey(repositoryType)) {
      _map[objectType]![repositoryType] = _factory.create<I, O, R>();
    }

    return _map[objectType]![repositoryType] as ModelCacheBloc<I, O>;
  }

  ModelWithChildrenCacheBloc<I, O> getOrCreateWithChildren<
    I,
    O extends WithIdChildrenParent<I, O, O>,
    R extends AbstractRepository<I, O>
  >() {
    final objectType = _typeOf<O>();
    final repositoryType = _typeOf<R>();

    if (!_map.containsKey(objectType)) {
      _map[objectType] = <Type, ModelCacheBloc>{};
    }

    if (!_map[objectType]!.containsKey(repositoryType)) {
      _map[objectType]![repositoryType] = _factory.createWithChildren<I, O, R>();
    }

    return _map[objectType]![repositoryType] as ModelWithChildrenCacheBloc<I, O>;
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
