import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:meta/meta.dart';

class ModelWithChildrenCacheBloc<I, O extends WithIdChildren<I, O>> extends ModelCacheBloc<I, O>{
  ModelWithChildrenCacheBloc({
    @required AbstractRepository<I, O> repository,
  }) : super(repository: repository);

  @override
  void addSuccessfulObject(O object) {
    super.addSuccessfulObject(object);

    for (final child in object.children) {
      super.addSuccessfulObject(child);
    }
  }
}
