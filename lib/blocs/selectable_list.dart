import 'dart:collection';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SelectableListCubit<I, F extends AbstractFilter> extends Bloc {
  final Map<I, I> _allIds = Map<I, I>();
  final Map<I, I> _selectedIds = Map<I, I>();
  bool _canSelectMore = false;
  bool _wasSourceListEverNotEmpty = false;
  F _filter = null;

  final initialState = SelectableListState<I, F>(
    selected: false,
    selectedIds: Map<I, I>(),
    canSelectMore: false,
    isEmpty: true,
    wasEmptied: false,
    filter: null,
  );

  final _outStateController = BehaviorSubject<SelectableListState<I, F>>();
  Stream<SelectableListState<I, F>> get outState => _outStateController.stream;

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
        selectedIds: UnmodifiableMapView<I, I>(_selectedIds),
        canSelectMore: _canSelectMore,
        isEmpty: _allIds.isEmpty,
        wasEmptied: _allIds.isEmpty && _wasSourceListEverNotEmpty,
        filter: _filter,
      ),
    );
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class SelectableListState<I, F extends AbstractFilter> {
  final bool selected;
  final Map<I, I> selectedIds;
  final bool canSelectMore;
  final bool isEmpty;
  final bool wasEmptied;
  final F filter; // Nullable

  SelectableListState({
    @required this.selected,
    @required this.selectedIds,
    @required this.canSelectMore,
    @required this.isEmpty,
    @required this.wasEmptied,
    @required this.filter,
  });
}
