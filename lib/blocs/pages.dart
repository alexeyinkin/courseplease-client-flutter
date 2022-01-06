import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

import 'bloc.dart';

/// Encapsulates pages traversal over [listBloc].
class PagesBloc<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends Bloc {
  final F filter;
  final PageController pageController;
  final I initialId;
  final AbstractFilteredModelListBloc<I, O, F> listBloc;

  static const _transitionDuration = Duration(milliseconds: 300);
  static const _transitionCurve = Curves.ease;

  PagesBloc({
    required this.filter,
    required int initialIndex,
    required this.initialId,
  }) :
      listBloc = GetIt.instance.get<FilteredModelListCache>().getOrCreate<I, O, F, R>(filter),
      pageController = PageController(initialPage: initialIndex)
  ;

  int _requireCurrentIndex() {
    try {
      return pageController.page?.round() ?? pageController.initialPage;
    } catch (ex) {}
    return pageController.initialPage;
  }

  void nextPage() {
    pageController.nextPage(
      duration: _transitionDuration,
      curve: _transitionCurve,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: _transitionDuration,
      curve: _transitionCurve,
    );
  }

  PagesBlocItem<O>? getItemByIndex(int index) {
    final listState = listBloc.lastListState;

    if (index < 0 || index >= listState.objects.length) return null;
    return PagesBlocItem<O>(
      object: listState.objects[index],
      index: index,
      length: listState.objects.length,
    );
  }

  PagesBlocItem<O>? getCurrentItem() {
    final index = _requireCurrentIndex();
    return getItemByIndex(index);
  }

  I getCurrentId() {
    return getCurrentItem()?.object.id ?? initialId;
  }

  @override
  void dispose() {
    pageController.dispose();
  }
}

class PagesBlocItem<O extends WithId> {
  final O object;
  final int index;
  final int length;

  PagesBlocItem({
    required this.object,
    required this.index,
    required this.length,
  });

  bool get isFirst => index == 0;
  bool get isLast => index == length - 1;
}
