import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import '../models/filters/abstract.dart';
import '../models/interfaces.dart';
import 'object_abstract_list_view.dart';

class ObjectLinearListView<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListView<I, O, F, R, T> {
  ObjectLinearListView({
    required F filter,
    required TileFactory<I, O, F, T> tileFactory,
    TileCallback<I, O>? onTap,
    required Axis scrollDirection,
    bool reverse = false,
    Widget? titleIfNotEmpty,
    SelectableListCubit<I, F>? listStateCubit,
  }) : super(
    filter: filter,
    tileFactory: tileFactory,
    onTap: onTap,
    scrollDirection: scrollDirection,
    reverse: reverse,
    titleIfNotEmpty: titleIfNotEmpty,
    listStateCubit: listStateCubit,
  );

  @override
  State<ObjectLinearListView> createState() => ObjectLinearListViewState<I, O, F, R, T>();
}

class ObjectLinearListViewState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListViewState<I, O, F, R, T, ObjectLinearListView<I, O, F, R, T>> {
  final _scrollController = ScrollController(keepScrollOffset: false);

  @override
  Widget getListViewWidget(
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    return ListView.builder(
      controller:       _scrollController,
      key:              PageStorageKey('ObjectLinearListViewState_' + T.runtimeType.toString() + '_' + widget.filter.toString()),
      scrollDirection:  widget.scrollDirection,
      reverse:          widget.reverse,
      itemCount:        modelListState.hasMore ? null : modelListState.objects.length,
      itemBuilder:      (context, index) => buildTile(index, modelListState, listBloc, selectableListState),
    );
  }
}
