import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import '../models/filters/abstract.dart';
import '../models/interfaces.dart';
import 'object_abstract_list_view.dart';

class ObjectGrid<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListView<I, O, F, R, T> {
  final SliverGridDelegate gridDelegate;

  ObjectGrid({
    required F filter,
    required TileFactory<I, O, F, T> tileFactory,
    TileCallback<I, O>? onTap,
    required Axis scrollDirection,
    ScrollController? scrollController,
    bool reverse = false,
    required this.gridDelegate,
    Widget? titleIfNotEmpty,
    SelectableListCubit<I, F>? listStateCubit,
    bool shrinkWrap = false,
  }) : super(
    filter: filter,
    tileFactory: tileFactory,
    onTap: onTap,
    scrollDirection: scrollDirection,
    scrollController: scrollController,
    reverse: reverse,
    titleIfNotEmpty: titleIfNotEmpty,
    listStateCubit: listStateCubit,
    shrinkWrap: shrinkWrap,
  );

  @override
  State<ObjectGrid> createState() => ObjectGridState<I, O, F, R, T>();
}

class ObjectGridState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListViewState<I, O, F, R, T, ObjectGrid<I, O, F, R, T>> {
  final _scrollController = ScrollController(keepScrollOffset: false);

  @override
  Widget getListViewWidget(
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    return GridView.builder(
      controller:       widget.scrollController ?? _scrollController,
      key:              PageStorageKey('ObjectGrid_' + T.runtimeType.toString() + '_' + widget.filter.toString()),
      scrollDirection:  widget.scrollDirection,
      reverse:          widget.reverse,
      gridDelegate:     widget.gridDelegate,
      itemCount:        modelListState.hasMore ? null : modelListState.objects.length + 1,
      itemBuilder:      (context, index) => buildTile(index, modelListState, listBloc, selectableListState),
      shrinkWrap:       widget.shrinkWrap,
    );
  }
}
