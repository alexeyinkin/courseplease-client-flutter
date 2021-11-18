import 'dart:convert';
import 'dart:typed_data';

import 'package:ably_flutter/ably_flutter.dart';
import 'package:courseplease/blocs/realtime.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:sse_client/sse_client.dart';

import '../authentication.dart';
import 'ably_token_provider.dart';

class AblySseCubit extends AbstractRealtimeCubit {
  final RealtimeCredentials credentials;
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _serverSentEventsCubit = GetIt.instance.get<ServerSentEventsCubit>();

  TokenDetails? _tokenDetails;
  SseClient? _sseClient;
  bool _disposed = false;
  RealtimeStatus _status = RealtimeStatus.notAttempted;

  DateTime? _disconnectedDateTime;

  // Ably's continuous TTL is 2 minutes. Reserve 10 seconds to app delays.
  static const _continuousTtl = Duration(minutes: 1, seconds: 50);

  AblySseCubit({
    required this.credentials,
  }) {
    _init();
  }

  void _init() async {
    _tokenDetails = await AblyTokenProvider().getAuthToken();
    if (_tokenDetails?.token == null) return;

    final params = {
      'channels': _getChannelName(),
      'v': '1.2',
      'access_token': _tokenDetails!.token,
    };

    final uri = Uri.https(
      'realtime.ably.io',
      '/event-stream',
      params,
    );

    if (_disposed) return; // Disposed while waiting for token.
    _setStatus(RealtimeStatus.connecting);
    _sseClient = SseClient.connect(uri);

    _sseClient!.stream.listen(_onMessage);
    _sseClient!.errorEvents.listen((_) => _onError());
    _sseClient!.openEvents.listen((_) => _onOpen());
  }

  void _setStatusFromClient() {
    final readyState = _sseClient?.readyState;
    print('AblySseCubit readyState: ' + readyState.toString());

    switch (readyState) {
      case SseClientState.connecting:
        _setStatus(RealtimeStatus.connecting);
        break;
      case SseClientState.open:
        _setStatus(RealtimeStatus.connected);
        break;
      case SseClientState.closed:
        _setStatus(RealtimeStatus.failed);
        break;
    }
  }

  void _setStatus(RealtimeStatus status) {
    if (status != _status) {
      _status = status;

      final state = RealtimeState(status: _status);
      pushState(state);
    }
  }

  String _getChannelName() {
    return 'sse-v1-' + credentials.crossDeviceToken;
  }

  void _onMessage(String? message) async {
    _setStatusFromClient();

    if (message == null) {
      print('AblySseCubit message: null');
      return;
    }

    final map = jsonDecode(message);
    print('AblySseCubit message: ' + map['name']);

    try {
      final binaryData = base64Decode(map['data']);
      final decryptedBytes = decryptAes256Cbc(
        binaryData,
        credentials.encryptionKey,
        Uint8List.fromList('CoursePlease.com'.codeUnits),
      );
      final decryptedString = String.fromCharCodes(decryptedBytes);
      print('AblySseCubit decrypted $decryptedString');

      final sse = ServerSentEvent.fromMap(jsonDecode(decryptedString));
      _serverSentEventsCubit.applyEvents([sse]);
    } catch (_) {
      // TODO: Log the error.
      print('AblySseCubit cannot decrypt the message! Reloading the actor and the state.');
      await _authenticationCubit.reloadCurrentActor();
      _serverSentEventsCubit.reload();
    }
  }

  void _onError() {
    if (_disconnectedDateTime == null) _disconnectedDateTime = DateTime.now();

    final tokenExpireMilliseconds = _tokenDetails?.expires ?? 0;
    if (tokenExpireMilliseconds - DateTime.now().millisecondsSinceEpoch < 60000) {
      // 1 minute left or less
      print('AblySseCubit recreating on token expire');

      // TODO: Just reconnect instead of reloading if still continuous.
      _killThis();
      _serverSentEventsCubit.reload();
      return;
    }

    _setStatusFromClient();
  }

  void _onOpen() {
    if (_disconnectedDateTime != null) {
      final wasDisconnectedFor = DateTime.now().difference(_disconnectedDateTime!);
      if (wasDisconnectedFor > _continuousTtl) {
        print('AblySseCubit recreating on lost continuity');
        _killThis();
        _serverSentEventsCubit.reload();
        return;
      }
    }

    _disconnectedDateTime = null;
    _setStatusFromClient();
  }

  @override
  void dispose() async {
    _disposed = true;
    _killThis();
    super.dispose();
  }

  void _killThis() {
    _sseClient?.close();
    _sseClient = null;
  }
}

class AblySseCubitFactory extends RealtimeFactoryInterface {
  @override
  AbstractRealtimeCubit? createIfValid(RealtimeCredentials credentials) {
    return AblySseCubit(credentials: credentials);
  }
}
