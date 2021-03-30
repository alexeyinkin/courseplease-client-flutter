import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

abstract class AbstractRealtimeCubit extends Bloc {
  final _outStateController = BehaviorSubject<RealtimeState>();
  Stream<RealtimeState> get outState => _outStateController.stream;

  @protected
  void pushState(RealtimeState state) {
    _outStateController.sink.add(state);
  }

  @override
  @mustCallSuper
  void dispose() {
    _outStateController.close();
  }
}

class RealtimeState {
  final RealtimeStatus status;

  RealtimeState({
    required this.status,
  });
}

enum RealtimeStatus {
  notAttempted,
  connecting,
  connected,
  failed,
}
