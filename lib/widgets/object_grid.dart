import 'package:courseplease/blocs/filtered_model_list.dart';
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
  //final DownloadedObjectList<I, O, F> downloadedObjectList;
  final TileFactory<I, O, F, T> tileFactory;
  final TileCallback<I, O> onTap; // Nullable
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final Widget titleIfNotEmpty; // Nullable
  F filter = null;

  ObjectGrid({
    @required this.filter,
    //@required this.downloadedObjectList,
    @required this.tileFactory,
    this.onTap,
    @required this.scrollDirection,
    @required this.gridDelegate,
    this.titleIfNotEmpty,
  });

  @override
  State<ObjectGrid> createState() {
    return ObjectGridState<I, O, F, R, T>(
      //this.downloadedObjectList,
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
  final _factory = GetIt.instance.get<FilteredModelListFactory>();
  //DownloadedObjectList<I, O, F> _downloadedObjectList;
  final _scrollController = ScrollController(keepScrollOffset: false);
  final TileFactory<I, O, F, T> _tileFactory;

  ObjectGridState(
    //this._downloadedObjectList,
    this._tileFactory,
  );

  @override
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    //_loadMoreIfCan();
  }

  // void _loadMoreIfCan() {
  //   if (_downloadedObjectList.more) {
  //     _downloadedObjectList
  //         .loadMore()
  //         .then((loadResult) => setState(() {}));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final listBloc = _factory.getOrCreate<I, O, F, R>(widget.filter);
    listBloc.inEvents.add(LoadInitialIfNotEvent());

    return StreamBuilder(
      stream: listBloc.outState,
      initialData: listBloc.initialState,
      builder: (context, snapshot) => _buildWithListState(context, snapshot.data, listBloc),
    );
  }

  Widget _buildWithListState(BuildContext context, ModelListState listState, FilteredModelListBloc bloc) {
    //final length = _downloadedObjectList.objects.length;
    final length = listState.objects.length;
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
            //itemCount: _downloadedObjectList.more ? null : length,
            itemCount: listState.hasMore ? null : length,
            itemBuilder: (context, index) {
              print(length.toString() + ' in _objects.');
              if (index < length) {
                return _tileFactory(
                  //object: _downloadedObjectList.objects[index],
                  object: listState.objects[index],
                  index: index,
                  onTap: widget.onTap,
                );
              }

              //_loadMoreIfCan();
              bloc.inEvents.add(LoadMoreEvent());
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
}
