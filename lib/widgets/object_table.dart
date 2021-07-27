import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

typedef TableRowBuilder<O> = TableRow Function(BuildContext context, O object, int index);

// TODO: Sticky header.
class ObjectTableWidget<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends StatefulWidget {
  final F filter;
  final TableRow header;
  final TableRowBuilder<O> rowBuilder;
  final Map<int, TableColumnWidth>? columnWidths;

  ObjectTableWidget({
    required this.filter,
    required this.header,
    required this.rowBuilder,
    this.columnWidths,
  }) : super(
    key: ValueKey(filter.toString()),
  );

  @override
  _ObjectTableWidgetState createState() => _ObjectTableWidgetState<I, O, F, R>(
    filter: filter,
  );
}

class _ObjectTableWidgetState<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends State<ObjectTableWidget<I, O, F, R>> {
  final _scrollController = ScrollController();
  final AbstractFilteredModelListBloc<I, O, F> _listCubit;

  _ObjectTableWidgetState({
    required F filter,
  }) :
      _listCubit = GetIt.instance.get<FilteredModelListCache>().getOrCreate<I, O, F, R>(filter)
  ;

  @override
  Widget build(BuildContext context) {
    _listCubit.loadInitialIfNot();

    return StreamBuilder<ModelListState<I, O>>(
      stream: _listCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _listCubit.initialState),
    );
  }

  Widget _buildWithState(ModelListState<I, O> state) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) => _buildListItem(state, index),
    );
  }

  Widget _buildListItem(ModelListState<I, O> state, int index) {
    switch (index) {
      case 0:
        return _buildTable(state);
    }

    _listCubit.loadMoreIfCan();
    return state.hasMore
        ? Container(padding: EdgeInsets.all(10), child: SmallCircularProgressIndicator())
        : Container();
  }

  Widget _buildTable(ModelListState<I, O> state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: widget.columnWidths,
        children: [widget.header, ..._getRows(state)],
      ),
    );
  }

  List<TableRow> _getRows(ModelListState<I, O> state) {
    final result = <TableRow>[];

    for (int i = 0; i < state.objects.length; i++) {
      result.add(
        widget.rowBuilder(context, state.objects[i], i),
      );
    }

    return result;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
