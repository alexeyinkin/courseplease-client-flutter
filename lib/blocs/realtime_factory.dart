import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/realtime.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'authentication.dart';

class RealtimeFactoryCubit extends Bloc {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationStreamSubscription;
  final Map<String, RealtimeFactoryInterface> factories;

  final _outStateController = BehaviorSubject<RealtimeState>();
  Stream<RealtimeState> get outState => _outStateController.stream;

  final initialState = RealtimeState(
    status: RealtimeStatus.notAttempted,
  );

  RealtimeCredentials? _credentials;
  AbstractRealtimeCubit? _realtime;
  StreamSubscription? _realtimeSubscription;

  RealtimeFactoryCubit({
    required this.factories,
  }) {
    _authenticationStreamSubscription = _authenticationCubit.outState.listen(
      _onAuthenticationStateChange,
    );
  }

  void _onAuthenticationStateChange(AuthenticationState state) {
    final realtimeCredentials = state.data?.realtimeCredentials;

    if (realtimeCredentials == null) {
      _destroyRealtime();
    } else {
      _replaceRealtime(realtimeCredentials);
    }
  }

  void _destroyRealtime() {
    _realtimeSubscription?.cancel();
    _realtime?.dispose();
    _realtime = null;
    _credentials = null;
  }

  void _replaceRealtime(RealtimeCredentials credentials) {
    if (_credentials != null && _credentials!.getChecksum() == credentials.getChecksum()) {
      return;
    }

    _destroyRealtime();
    _createRealtime(credentials);

    _credentials = credentials;
  }

  void _createRealtime(RealtimeCredentials credentials) {
    final factory = factories[credentials.providerName];
    _realtime = factory?.createIfValid(credentials);

    if (_realtime == null) return;

    _realtimeSubscription = _realtime!.outState.listen(_onRealtimeStateChanged);
  }

  void _onRealtimeStateChanged(RealtimeState state) {
    _outStateController.sink.add(state);
  }

  @override
  void dispose() {
    _destroyRealtime();
    _outStateController.close();
    _authenticationStreamSubscription.cancel();
  }
}

abstract class RealtimeFactoryInterface {
  AbstractRealtimeCubit? createIfValid(RealtimeCredentials credentials);
}
