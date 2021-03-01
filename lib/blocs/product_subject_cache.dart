import 'package:courseplease/blocs/model_with_children_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/product_subject.dart';
import 'package:meta/meta.dart';

class ProductSubjectCacheBloc extends ModelWithChildrenCacheBloc<int, ProductSubject> {
  ProductSubjectCacheBloc({
    @required ProductSubjectRepository repository,
  }) : super(repository: repository) {
    print('Creating ProductSubjectCacheBloc');
    loadAll();
  }
}
