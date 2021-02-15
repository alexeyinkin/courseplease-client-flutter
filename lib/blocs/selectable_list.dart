import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SelectableListCubit<T> extends Bloc {
  final Map<T, T> _allIds = Map<T, T>();
  final Map<T, T> _selectedIds = Map<T, T>();
  bool _canSelectMore = false;
  bool _wasSourceListEverNotEmpty = false;

  final initialState = SelectableListState<T>(
    selected: false,
    selectedIds: Map<T, T>(),
    canSelectMore: false,
    isEmpty: true,
    wasEmptied: false,
  );

  final _outStateController = BehaviorSubject<SelectableListState<T>>();
  Stream<SelectableListState<T>> get outState => _outStateController.stream;

  void select(T key) {
    if (!_selectedIds.containsKey(key)) {
      _selectedIds[key] = key;
      _onChanged();
    }
  }

  void deselect(T key) {
    if (_selectedIds.containsKey(key)) {
      _selectedIds.remove(key);
      _onChanged();
    }
  }

  void setSelected(T key, bool selected) {
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

  void setAll(List<T> allIds) {
    _allIds.clear();
    for (final id in allIds) {
      _allIds[id] = id;
    }

    for (final id in _selectedIds.keys) {
      if (!_allIds.containsKey(id)) {
        allIds.remove(id);
      }
    }

    if (allIds.isNotEmpty) {
      _wasSourceListEverNotEmpty = true;
    }

    _onChanged();
  }

  void _onChanged() {
    _canSelectMore = _selectedIds.length < _allIds.length;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      SelectableListState(
        selected: _selectedIds.isNotEmpty,
        selectedIds: UnmodifiableMapView<T, T>(_selectedIds),
        canSelectMore: _canSelectMore,
        isEmpty: _allIds.isEmpty,
        wasEmptied: _allIds.isEmpty && _wasSourceListEverNotEmpty,
      ),
    );
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class SelectableListState<T> {
  final bool selected;
  final Map<T, T> selectedIds;
  final bool canSelectMore;
  final bool isEmpty;
  final bool wasEmptied;

  SelectableListState({
    @required this.selected,
    @required this.selectedIds,
    @required this.canSelectMore,
    @required this.isEmpty,
    @required this.wasEmptied,
  });
}
