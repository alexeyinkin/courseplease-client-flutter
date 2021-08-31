import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:rxdart/rxdart.dart';

class FilterScreenCubit<F extends AbstractFilter> extends Bloc {
  final _statesController = BehaviorSubject<FilterScreenCubitState>();
  Stream<FilterScreenCubitState> get states => _statesController.stream;
  late final FilterScreenCubitState initialState;

  final _successesController = BehaviorSubject<FilterScreenResult<F>>();
  Stream<FilterScreenResult<F>> get successes => _successesController.stream;

  final AbstractFilterScreenContentCubit<F> contentCubit;

  FilterScreenCubit({
    required this.contentCubit,
  }) {
    initialState = _createState();
  }

  FilterScreenCubitState _createState() {
    return FilterScreenCubitState(
      canClear: _getCanClear(),
    );
  }

  bool _getCanClear() {
    return true; // TODO: Subscribe to the content's state, use its one.
  }

  void clear() {
    contentCubit.clear();
  }

  void apply() {
    final filter = contentCubit.getFilter();
    _successesController.sink.add(
      FilterScreenResult<F>(
        filter: filter,
      ),
    );
  }

  @override
  void dispose() {
    _statesController.close();
    _successesController.close();
  }
}

class FilterScreenCubitState {
  final bool canClear;

  FilterScreenCubitState({
    required this.canClear,
  });
}

class FilterScreenResult<F extends AbstractFilter> {
  final F filter;

  FilterScreenResult({
    required this.filter,
  });
}

abstract class AbstractFilterScreenContentCubit<F extends AbstractFilter> extends Bloc {
  void clear();
  void setFilter(F filter);
  F getFilter();
}
