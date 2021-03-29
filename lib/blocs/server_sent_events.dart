import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/sse/sse_listener_locator.dart';
import 'package:courseplease/services/sse/sse_reloader_locator.dart';
import 'package:get_it/get_it.dart';

import 'authentication.dart';

class ServerSentEventsCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _listenerLocator = GetIt.instance.get<SseListenerLocator>();
  final _reloaderLocator = GetIt.instance.get<SseReloaderLocator>();

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationCubitSubscription;

  _CubitStatus _status = _CubitStatus.initial;

  /// Not null if upToDate. This is set back to null if we run behind.
  int? _lastSseId;

  ServerSentEventsCubit() {
    _authenticationCubitSubscription = _authenticationCubit.outState.listen(
      _onAuthenticationStateChange
    );
  }

  void _onAuthenticationStateChange(AuthenticationState state) {
    final lastSseId = state.data?.lastSseId;

    if (lastSseId == _lastSseId) {
      return; // An auth reload that showed no change.
    }

    switch (_status) {
      case _CubitStatus.initial:
      case _CubitStatus.reloading:
        if (lastSseId == null) {
          return; // Still not signed in.
        }
        // Not reloading. Consider everything is freshly loaded and up-to-date.
        _setAcceptingEvents(lastSseId);
        break;

      case _CubitStatus.acceptingEvents:
        reload();
        break;

      case _CubitStatus.signedOut:
        if (lastSseId == null) {
          return; // Still not signed in.
        }
        reload();
        _setAcceptingEvents(lastSseId);
        break;
    }
  }

  void _setAcceptingEvents(int lastSseId) {
    _lastSseId = lastSseId;
    _status = _CubitStatus.acceptingEvents;
  }

  void reload() async {
    _lastSseId = null;
    _status = _CubitStatus.reloading;

    // Will bring fresh lastSseId.
    // TODO: Return fresh lastSseId together with /sse error?
    await _authenticationCubit.reloadCurrentActor();

    for (final reloader in _reloaderLocator.getAll()) {
      reloader.reload();
    }
  }

  void setLastSseId(int lastSseId) {
    _lastSseId = lastSseId;
  }

  void poll() async {
    if (_lastSseId == null) {
      throw Exception('lastSseId is not set');
    }
    final response = await _apiClient.getServerSentEvents(_lastSseId!);

    if (response.items == null) {
      reload();
      return;
    }
    applyEvents(response.items!);
  }

  void applyEvents(List<ServerSentEvent> events) {
    for (final sse in events) {
      _applyEvent(sse);
    }
  }

  void _applyEvent(ServerSentEvent sse) {
    _lastSseId = sse.id;
    final listener = _listenerLocator.get(sse.type);

    if (listener == null) {
      // TODO: Suggest app update.
      return;
    }

    listener.onEvent(sse);
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
  }
}

enum _CubitStatus {
  /// The user has not authenticated since app start.
  /// No lastSseId, as it will be received from the first authentication event.
  initial,

  /// Either everything is up-to-date, or reloaders will soon make it so.
  /// Either way, accept and apply new events.
  acceptingEvents,

  /// Differs from [initial] in that after sign in a reload is required.
  signedOut,

  /// Have requested fresh lastSseId from /me but have not yet received it.
  reloading,
}
