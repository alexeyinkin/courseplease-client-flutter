import 'package:courseplease/blocs/editors/with_id_title.dart';
import 'package:courseplease/models/interfaces.dart';

import '../model_cache.dart';
import '../models_by_ids.dart';
import 'abstract_list.dart';

class WithIdTitleListEditorController<
  I,
  O extends WithIdTitle<I>
> extends AbstractValueListEditorController<O, WithIdTitleEditorController<I, O>> {
  final ModelListByIdsBloc<I, O> _modelListByIds;

  WithIdTitleListEditorController({
    required int maxLength,
    required ModelCacheBloc<I, O> modelCacheBloc,
  }) :
      _modelListByIds = ModelListByIdsBloc<I, O>(modelCacheBloc: modelCacheBloc),
      super(
        maxLength: maxLength,
      )
  {
    _modelListByIds.outState.listen(_onStateChanged);
  }

  void _onStateChanged(ModelListByIdsState<O> state) {
    setValue(state.objects);
  }

  List<I> getIds() {
    final result = <I>[];

    for (final obj in getValue()) {
      if (obj == null) continue;
      result.add(obj.id);
    }

    return result;
  }

  void setIds(List<I> ids) {
    _modelListByIds.setCurrentIds(ids);
  }

  @override
  WithIdTitleEditorController<I, O> createController() {
    return WithIdTitleEditorController<I, O>();
  }
}
