import 'package:courseplease/blocs/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// A Cubit that runs actions on objects.
/// During an action it is disabled for other actions.
abstract class ListActionCubit<I, A> extends Bloc {
  final _outStateController = BehaviorSubject<ListActionCubitState<A>>();
  Stream<ListActionCubitState<A>> get outState => _outStateController.stream;

  final initialState = ListActionCubitState<A>(
    enabled: true,
    actionInProgress: null,
  );

  A _actionInProgress;

  @protected
  void pushOutput() {
    final state = ListActionCubitState(
      enabled: _actionInProgress == null,
      actionInProgress: _actionInProgress,
    );
    _outStateController.sink.add(state);
  }

  @protected
  void setActionInProgress(A action) { // Nullable
    _actionInProgress = action;
    pushOutput();
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class ListActionCubitState<A> {
  final bool enabled;
  final A actionInProgress; // Nullable
  ListActionCubitState({
    @required this.enabled,
    @required this.actionInProgress,
  });
}

enum MediaSortActionEnum {
  move,
  link,
  unlink,
  delete,
}
