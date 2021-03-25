import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import '../models/filters/abstract.dart';
import '../models/interfaces.dart';
import 'object_abstract_list_view.dart';

class SeparatorCreationRequest<I, O extends WithId<I>> {
  final BuildContext context;
  final O? previous;
  final O? next;
  final int nextIndex;

  SeparatorCreationRequest({
    required this.context,
    required this.previous,
    required this.next,
    required this.nextIndex,
  });
}

typedef Widget ObjectListSeparatorBuilder<I, O extends WithId<I>>(SeparatorCreationRequest<I, O> request);

class ObjectLinearListView<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends ObjectAbstractListView<I, O, F, R, T> {
  final ObjectListSeparatorBuilder<I, O>? separatorBuilder;

  ObjectLinearListView({
    required F filter,
    required TileFactory<I, O, F, T> tileFactory,
    TileCallback<I, O>? onTap,
    required Axis scrollDirection,
    ScrollController? scrollController,
    bool reverse = false,
    Widget? titleIfNotEmpty,
    this.separatorBuilder,
    SelectableListCubit<I, F>? listStateCubit,
  }) : super(
    filter: filter,
    tileFactory: tileFactory,
    onTap: onTap,
    scrollDirection: scrollDirection,
    scrollController: scrollController,
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
    late final itemCount;
    late final itemBuilder;

    if (widget.separatorBuilder == null) {
      itemCount = modelListState.hasMore ? null : modelListState.objects.length;
      itemBuilder = (context, index) => buildTile(index, modelListState, listBloc, selectableListState);
    } else {
      itemCount = modelListState.hasMore ? null : modelListState.objects.length * 2 + 1;
      itemBuilder = (context, index) => _buildTileOrSeparator(index, modelListState, listBloc, selectableListState);
    }

    return ListView.builder(
      controller:       widget.scrollController ?? _scrollController,
      key:              PageStorageKey('ObjectLinearListViewState_' + T.runtimeType.toString() + '_' + widget.filter.toString()),
      scrollDirection:  widget.scrollDirection,
      reverse:          widget.reverse,
      itemCount:        itemCount,
      itemBuilder:      itemBuilder,
    );
  }

  Widget _buildTileOrSeparator(
    int index,
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    if (index.isOdd) {
      final int objectIndex = ((index - 1) / 2).floor();
      return buildTile(objectIndex, modelListState, listBloc, selectableListState);
    }

    final int nextIndex = (index / 2).floor();

    final next = nextIndex >= modelListState.objects.length
        ? null
        : modelListState.objects[nextIndex];

    final previous = nextIndex == 0 || nextIndex > modelListState.objects.length
        ? null
        : modelListState.objects[nextIndex - 1];

    return widget.separatorBuilder!(
      SeparatorCreationRequest<I, O>(
        context: context,
        previous: previous,
        next: next,
        nextIndex: nextIndex,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
