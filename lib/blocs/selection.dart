import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// TODO: Rename to something like 'ListStateCubit'.
class SelectionCubit<T> extends Bloc {
  final Map<T, T> _all = Map<T, T>();
  final Map<T, T> _selected = Map<T, T>();
  bool _canSelectMore = false;
  bool _wasSourceListEverNotEmpty = false;

  final initialState = SelectionState<T>(
    selected: false,
    selectedIds: Map<T, T>(),
    canSelectMore: false,
    isSourceListEmpty: true,
    wasSourceListEmptied: false,
  );

  final _outStateController = BehaviorSubject<SelectionState<T>>();
  Stream<SelectionState<T>> get outState => _outStateController.stream;

  void select(T key) {
    if (!_selected.containsKey(key)) {
      _selected[key] = key;
      _onChanged();
    }
  }

  void deselect(T key) {
    if (_selected.containsKey(key)) {
      _selected.remove(key);
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
    if (_selected.isNotEmpty) {
      _selected.clear();
      _onChanged();
    }
  }

  void selectAll() {
    final countWas = _selected.length;
    _selected.addAll(_all);

    if (_selected.length != countWas) {
      _onChanged();
    }
  }

  void setAll(List<T> all) {
    _all.clear();
    for (final key in all) {
      _all[key] = key;
    }

    for (final key in _selected.keys) {
      if (!_all.containsKey(key)) {
        all.remove(key);
      }
    }

    if (all.isNotEmpty) {
      _wasSourceListEverNotEmpty = true;
    }

    _onChanged();
  }

  void _onChanged() {
    _canSelectMore = _selected.length < _all.length;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      SelectionState(
        selected: _selected.isNotEmpty,
        selectedIds: UnmodifiableMapView<T, T>(_selected),
        canSelectMore: _canSelectMore,
        isSourceListEmpty: _all.isEmpty,
        wasSourceListEmptied: _all.isEmpty && _wasSourceListEverNotEmpty,
      ),
    );
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class SelectionState<T> {
  final bool selected;
  final Map<T, T> selectedIds;
  final bool canSelectMore;
  final bool isSourceListEmpty;
  final bool wasSourceListEmptied;

  SelectionState({
    @required this.selected,
    @required this.selectedIds,
    @required this.canSelectMore,
    @required this.isSourceListEmpty,
    @required this.wasSourceListEmptied,
  });
}
