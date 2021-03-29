import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';

import 'authentication.dart';

class RealtimeFactoryCubit extends Bloc {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationStreamSubscription;
  final Map<String, RealtimeFactoryInterface> factories;

  RealtimeCredentials? _credentials;
  Bloc? _realtime;

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
    _realtime?.dispose();
    _realtime = null;
    _credentials = null;
  }

  void _replaceRealtime(RealtimeCredentials credentials) {
    if (_credentials != null && _credentials!.getChecksum() == credentials.getChecksum()) {
      return;
    }

    _realtime?.dispose();
    _realtime = _createRealtime(credentials);

    _credentials = credentials;
  }

  Bloc? _createRealtime(RealtimeCredentials credentials) {
    final factory = factories[credentials.providerName];
    return factory?.createIfValid(credentials);
  }

  @override
  void dispose() {
    _authenticationStreamSubscription.cancel();
  }
}

abstract class RealtimeFactoryInterface {
  Bloc? createIfValid(RealtimeCredentials credentials);
}
