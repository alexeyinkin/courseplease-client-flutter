import 'dart:collection';
import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/models/interfaces/with_id_title_intname_homogenous_children_parent.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:rxdart/rxdart.dart';

class ModelWithChildrenCacheBloc<I, O extends WithIdTitleIntNameHomogenousChildrenParent<I, O>> extends ModelCacheBloc<I, O>{
  final _topLevelObjectsInOrder = <O>[];
  final _objectsBySlashedPaths = <String, O>{};

  final _outTopLevelObjectsController = BehaviorSubject<List<O>>();
  Stream<List<O>> get outTopLevelObjects => _outTopLevelObjectsController.stream;

  ModelWithChildrenCacheBloc({
    required AbstractRepository<I, O> repository,
  }) : super(repository: repository);

  @override
  void addSuccessfulObject(O object) {
    super.addSuccessfulObject(object);

    for (final child in object.children) {
      super.addSuccessfulObject(child);
    }

    if (object.parent == null) {
      _topLevelObjectsInOrder.add(object);
    }

    _objectsBySlashedPaths[WithIdTitleIntNameHomogenousChildrenParent.getIntNamePath(object, '/')] = object;
  }

  void pushOutput() {
    super.pushOutput();
    _outTopLevelObjectsController.sink.add(UnmodifiableListView<O>(_topLevelObjectsInOrder));
  }

  O? getObjectBySlashedPath(String path) {
    return _objectsBySlashedPaths[path];
  }

  @override
  void dispose() {
    _outTopLevelObjectsController.close();
    super.dispose();
  }
}
