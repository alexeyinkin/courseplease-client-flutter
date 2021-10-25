import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';
import '../models/filters/abstract.dart';
import 'error/error_loading_more.dart';

abstract class ObjectAbstractListView<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>
> extends StatefulWidget {
  final F filter;
  final TileFactory<I, O, F, T> tileFactory;
  final TileCallback<I, O>? onTap;
  final Axis scrollDirection;
  final ScrollController? scrollController;
  final bool reverse;
  final Widget? titleIfNotEmpty;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? errorLoadingMoreBuilder;

  // shrinkWrap = true causes some http requests to stall. Use with caution.
  // One example is CommentListWidget.
  // TODO: Find the reason and fix.
  final bool shrinkWrap;

  final SelectableListCubit<I, F>? listStateCubit;

  ObjectAbstractListView({
    required this.filter,
    required this.tileFactory,
    this.onTap,
    required this.scrollDirection,
    this.scrollController,
    required this.reverse,
    this.titleIfNotEmpty,
    this.emptyBuilder,
    this.errorLoadingMoreBuilder,
    this.shrinkWrap = false,
    this.listStateCubit,
  });
}

abstract class ObjectAbstractListViewState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>,
  T extends AbstractObjectTile<I, O, F>,
  W extends ObjectAbstractListView<I, O, F, R, T>
> extends State<W> with AutomaticKeepAliveClientMixin<W> {
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  @override
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState(); // For AutomaticKeepAliveClientMixin.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // For AutomaticKeepAliveClientMixin.

    final listBloc = _filteredModelListCache.getOrCreate<I, O, F, R>(widget.filter);
    listBloc.loadInitialIfNot();

    return StreamBuilder<ModelListState<I, O>>(
      stream: listBloc.outState,
      builder: (context, snapshot) => _buildWithListState(
        context,
        snapshot.data ?? listBloc.initialState,
        listBloc,
      ),
    );
  }

  Widget _buildWithListState(
    BuildContext context,
    ModelListState<I, O> listState,
    AbstractFilteredModelListBloc listBloc,
  ) {
    if (widget.listStateCubit == null) {
      return _buildWithListAndSelectionStates(context, listState, listBloc, null);
    }

    widget.listStateCubit!.setAll(listState.objectIds);

    return StreamBuilder<SelectableListState<I, F>>(
      stream: widget.listStateCubit!.states,
      builder: (context, snapshot) => _buildWithListAndSelectionStates(
        context,
        listState,
        listBloc,
        snapshot.data ?? widget.listStateCubit!.initialState,
      ),
    );
  }

  Widget _buildWithListAndSelectionStates(
    BuildContext context,
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    final length = modelListState.objects.length;
    final children = <Widget>[];

    if (length > 0 && widget.titleIfNotEmpty != null) {
      children.add(widget.titleIfNotEmpty!);
    }

    final listViewWidget = RefreshIndicator(
      onRefresh: listBloc.clearAndLoadFirstPage,
      child: getListViewWidget(
        modelListState,
        listBloc,
        selectableListState,
      ),
    );

    children.add(
      widget.shrinkWrap
          ? listViewWidget
          : Expanded(child: listViewWidget),
    );

    return Container(
      // If no objects, set small height so they have a chance to load.
      // Otherwise do not interfere with height, let the outer code to set it.
      height: length > 0 ? null : 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget getListViewWidget(
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  );

  @protected
  Widget buildTile(
    int index,
    ModelListState<I, O> modelListState,
    AbstractFilteredModelListBloc listBloc,
    SelectableListState<I, F>? selectableListState,
  ) {
    final length = modelListState.objects.length;

    if (index < length) {
      final object = modelListState.objects[index];
      final selected = selectableListState == null
          ? false
          : selectableListState.selectedIds.containsKey(object.id);

      final request = TileCreationRequest<I, O, F>(
        object: object,
        index: index,
        filter: widget.filter,
        onTap: () => _onTap(object, index),
        selected: selected,
        onSelected: (selected) => _onSelected(object, selected),
      );
      return widget.tileFactory(request);
    }

    if (index == length) {
      return _buildTrailing(modelListState);
    }

    listBloc.loadMoreIfCan();
    return Text(index.toString());
  }

  void _onTap(O object, int index) {
    if (widget.onTap != null) {
      widget.onTap!(object, index);
    }
  }

  void _onSelected(O object, bool selected) {
    widget.listStateCubit?.setSelected(object.id, selected);
  }

  Widget _buildTrailing(ModelListState<I, O> modelListState) {
    if (modelListState.status == RequestStatus.error) {
      return _buildErrorLoadingMoreWidget();
    }

    return Container();
  }

  Widget _buildErrorLoadingMoreWidget() {
    if (widget.errorLoadingMoreBuilder == null) {
      return ErrorLoadingMoreWidget();
    }

    return widget.errorLoadingMoreBuilder!(context);
  }
}
