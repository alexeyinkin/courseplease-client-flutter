import 'dart:collection';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:rxdart/rxdart.dart';

class SelectableListCubit<I, F extends AbstractFilter> extends Bloc {
  final Map<I, I> _allIds = Map<I, I>();
  final Map<I, I> _selectedIds = Map<I, I>();
  bool _canSelectMore = false;
  bool _wasSourceListNotEmpty = false;
  F _filter;

  late SelectableListState<I, F> initialState;

  final _statesController = BehaviorSubject<SelectableListState<I, F>>();
  Stream<SelectableListState<I, F>> get states => _statesController.stream;

  final _emptiedController = BehaviorSubject<void>();
  Stream<void> get emptied => _emptiedController.stream;

  SelectableListCubit({
    required F initialFilter,
  }) :
      _filter = initialFilter
  {
    initialState = SelectableListState<I, F>(
      selected: false,
      selectedIds: Map<I, I>(),
      canSelectMore: false,
      isEmpty: true,
      filter: initialFilter,
    );
  }

  void setFilter(F filter) {
    _filter = filter;
    _pushOutput();
  }

  void select(I key) {
    if (!_selectedIds.containsKey(key)) {
      _selectedIds[key] = key;
      _onChanged();
    }
  }

  void deselect(I key) {
    if (_selectedIds.containsKey(key)) {
      _selectedIds.remove(key);
      _onChanged();
    }
  }

  void setSelected(I key, bool selected) {
    if (selected) {
      select(key);
    } else {
      deselect(key);
    }
  }

  void selectNone() {
    if (_selectedIds.isNotEmpty) {
      _selectedIds.clear();
      _onChanged();
    }
  }

  void selectAll() {
    final countWas = _selectedIds.length;
    _selectedIds.addAll(_allIds);

    if (_selectedIds.length != countWas) {
      _onChanged();
    }
  }

  void setAll(List<I> allIds) {
    _allIds.clear();
    for (final id in allIds) {
      _allIds[id] = id;
    }

    _selectedIds.removeWhere((key, _) => !_allIds.containsKey(key));

    if (allIds.isNotEmpty) {
      _wasSourceListNotEmpty = true;
    }

    _onChanged();
  }

  void _onChanged() {
    _canSelectMore = _selectedIds.length < _allIds.length;

    if (_allIds.isEmpty && _wasSourceListNotEmpty) {
      _wasSourceListNotEmpty = false;
      _emptiedController.sink.add(true);
    }

    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(
      SelectableListState(
        selected: _selectedIds.isNotEmpty,
        selectedIds: UnmodifiableMapView<I, I>(_selectedIds),
        canSelectMore: _canSelectMore,
        isEmpty: _allIds.isEmpty,
        filter: _filter,
      ),
    );
  }

  @override
  void dispose() {
    _statesController.close();
    _emptiedController.close();
  }
}

class SelectableListState<I, F extends AbstractFilter> {
  final bool selected;
  final Map<I, I> selectedIds;
  final bool canSelectMore;
  final bool isEmpty;
  final F filter;

  SelectableListState({
    required this.selected,
    required this.selectedIds,
    required this.canSelectMore,
    required this.isEmpty,
    required this.filter,
  });
}
