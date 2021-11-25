import 'package:model_editors/model_editors.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../model_cache.dart';
import '../models_by_ids.dart';

class WithIdTitleListEditorController<
  I,
  O extends WithIdTitle<I>
> extends AbstractListEditingController<O, WithIdTitleEditingController<I, O>> {
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

  void _onStateChanged(ModelListByIdsState<I, O> state) {
    value = state.objects;
  }

  List<I> getIds() {
    final result = <I>[];

    for (final obj in value) {
      if (obj == null) continue;
      result.add(obj.id);
    }

    return result;
  }

  void setIds(List<I> ids) {
    _modelListByIds.setCurrentIds(ids);
  }

  @override
  WithIdTitleEditingController<I, O> createItemController() {
    return WithIdTitleEditingController<I, O>();
  }
}
