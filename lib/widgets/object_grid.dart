import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/filters/abstract.dart';
import '../models/interfaces.dart';

class ObjectGrid<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends StatefulWidget {
  final TileFactory<I, O, F, T> tileFactory;
  final TileCallback<I, O> onTap; // Nullable
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable
  final SelectableListCubit<I, F> listStateCubit; // Nullable
  F filter = null;

  ObjectGrid({
    @required this.filter,
    @required this.tileFactory,
    this.onTap, // Nullable
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty, // Nullable
    this.listStateCubit, // Nullable
  });

  @override
  State<ObjectGrid> createState() {
    return ObjectGridState<I, O, F, R, T>(
      this.tileFactory,
    );
  }
}

class ObjectGridState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends State<ObjectGrid<I, O, F, R, T>> with AutomaticKeepAliveClientMixin<ObjectGrid<I, O, F, R, T>> {
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();
  final _scrollController = ScrollController(keepScrollOffset: false);
  final TileFactory<I, O, F, T> _tileFactory;

  ObjectGridState(
    this._tileFactory,
  );

  @override
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState(); // For AutomaticKeepAliveClientMixin.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final listBloc = _filteredModelListCache.getOrCreate<I, O, F, R>(widget.filter);
    listBloc.loadInitialIfNot();

    return StreamBuilder(
      stream: listBloc.outState,
      initialData: listBloc.initialState,
      builder: (context, snapshot) => _buildWithListState(context, snapshot.data, listBloc),
    );
  }

  Widget _buildWithListState(
    BuildContext context,
    ModelListState<I, O> listState,
    FilteredModelListBloc listBloc,
  ) {
    if (widget.listStateCubit == null) {
      return _buildWithListAndSelectionStates(context, listState, listBloc, null);
    }

    widget.listStateCubit.setAll(listState.objectIds);

    return StreamBuilder(
      stream: widget.listStateCubit.outState,
      initialData: widget.listStateCubit.initialState,
      builder: (context, snapshot) => _buildWithListAndSelectionStates(context, listState, listBloc, snapshot.data),
    );
  }

  Widget _buildWithListAndSelectionStates(
    BuildContext context,
    ModelListState<I, O> modelListState,
    FilteredModelListBloc listBloc,
    SelectableListState<I, F> selectionState, // Nullable
  ) {
    final length = modelListState.objects.length;
    final children = <Widget>[];

    if (length > 0 && widget.titleIfNotEmpty != null) {
      children.add(widget.titleIfNotEmpty);
    }

    //if (length > 0) {
    if (true) {
      children.add(
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            key: PageStorageKey('ObjectGrid_' + T.runtimeType.toString() + '_' +
                widget.filter.toString()),
            scrollDirection: widget.scrollDirection,
            gridDelegate: widget.gridDelegate,
            itemCount: modelListState.hasMore ? null : length,
            itemBuilder: (context, index) {
              if (index < length) {
                final object = modelListState.objects[index];
                return _tileFactory(
                  object: object,
                  index: index,
                  onTap: () => widget.onTap(object, index),
                  selected: selectionState == null ? false : selectionState.selectedIds.containsKey(object.id),
                  onSelected: (selected) => _onSelected(object, selected),
                );
              }

              listBloc.loadMoreIfCan();
              return Text(index.toString());
            },
          ),
        ),
      );
    }

    return Container(
      // If no objects, keep height at 1px so they have a chance to load.
      // Otherwise do not interfere with height and allow the outer code to set it.
      height: length > 0 ? null : 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  void _onSelected(O object, bool selected) {
    if (widget.listStateCubit != null) {
      widget.listStateCubit.setSelected(object.id, selected);
    }
  }
}
