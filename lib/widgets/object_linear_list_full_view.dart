import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:flutter/material.dart';

import 'abstract_object_tile.dart';
import 'object_abstract_list_view.dart';

class ObjectLinearListFullView<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListView<I, O, F, R, T> {
  ObjectLinearListFullView({
    required F filter,
    required TileFactory<I, O, F, T> tileFactory,
    TileCallback<I, O>? onTap,
    required Axis scrollDirection,
    ScrollController? scrollController,
    bool reverse = false,
    Widget? titleIfNotEmpty,
  }) : super(
    filter: filter,
    tileFactory: tileFactory,
    onTap: onTap,
    scrollDirection: scrollDirection,
    scrollController: scrollController,
    reverse: reverse,
    titleIfNotEmpty: titleIfNotEmpty,
    shrinkWrap: true,
  );

  @override
  State<ObjectLinearListFullView> createState() => _ObjectLinearListFullViewState<I, O, F, R, T>();
}

class _ObjectLinearListFullViewState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListViewState<I, O, F, R, T, ObjectLinearListFullView<I, O, F, R, T>> {
  @override
  Widget getListViewWidget(
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    final children = <Widget>[];

    listBloc.loadAll();

    var i = 0;
    for (final object in modelListState.objects) {
      children.add(
        buildTile(i, modelListState, listBloc, selectableListState),
      );
      i++;
    }

    return Column(
      children: children,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
