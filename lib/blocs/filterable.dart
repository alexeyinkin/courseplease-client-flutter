import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/abstract.dart';

abstract class FilterableCubit<F extends AbstractFilter> extends Bloc {
  Stream<FilterableCubitState<F>> get states;
  FilterableCubitState<F> get initialState;

  void setFilter(F filter);
}

abstract class FilterableCubitState<F extends AbstractFilter> {
  F get filter;
}
