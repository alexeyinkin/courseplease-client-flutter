import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:courseplease/blocs/realtime.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import '../authentication.dart';

class AblyNativeProtocolCubit extends AbstractRealtimeCubit {
  final RealtimeCredentials credentials;
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _serverSentEventsCubit = GetIt.instance.get<ServerSentEventsCubit>();

  ably.Realtime? _realtime;
  ably.RealtimeChannel? _channel;
  Stream<ably.Message>? _messageStream;
  StreamSubscription? _channelMessageSubscription;
  bool _wasEverContinuous = false;
  bool _reloadAllOnAttach = false;

  AblyNativeProtocolCubit({
    required this.credentials,
  }) {
    _init();
  }

  void _init() async {
    final clientOptions = ably.ClientOptions();
    clientOptions.authCallback = _getAuthToken;

    _realtime = ably.Realtime(options: clientOptions);
    await _realtime!.connect();
    _realtime!.connection.on().listen(_onStateChange);

    _channel = _realtime!.channels.get(_getChannelName());
    _channel!.on().listen(_onChannelStateChange);
    await _channel!.attach();

    _messageStream = _channel!.subscribe();
    _channelMessageSubscription = _messageStream!.listen(_onMessage);
  }

  Future<ably.TokenRequest> _getAuthToken(ably.TokenParams params) async {
    final meResponseData = await _apiClient.getMe();
    final tokenRequestJson = meResponseData.realtimeCredentials?.providerToken;

    if (tokenRequestJson == null) {
      print('COURSEPLEASE: Returning null token request.');
      throw Exception('COURSEPLEASE: Returning null token request.');
    }

    final tokenRequestMap = jsonDecode(tokenRequestJson);
    final tokenRequest = ably.TokenRequest.fromMap(tokenRequestMap);
    print('COURSEPLEASE: Returning valid token request.');
    return tokenRequest;
  }

  void _onStateChange(ably.ConnectionStateChange stateChange) {
    print('Ably realtime connection state changed: ${stateChange.event}');

    final status = _connectionStateToRealtimeStatus(stateChange.current);
    final state = RealtimeState(status: status);
    pushState(state);
  }

  RealtimeStatus _connectionStateToRealtimeStatus(ably.ConnectionState state) {
    switch (state) {
      case ably.ConnectionState.initialized:
      case ably.ConnectionState.closing:
      case ably.ConnectionState.closed:
        return RealtimeStatus.notAttempted;
      case ably.ConnectionState.connecting:
      case ably.ConnectionState.suspended:
        return RealtimeStatus.connecting;
      case ably.ConnectionState.connected:
        return RealtimeStatus.connected;
      case ably.ConnectionState.disconnected:
      case ably.ConnectionState.failed:
        return RealtimeStatus.failed;
    }
  }

  String _getChannelName() {
    return 'sse-v1-' + credentials.crossDeviceToken;
  }

  void _onChannelStateChange(ably.ChannelStateChange stateChange) {
    print("Ably channel state changed: ${stateChange.current}");

    if (!stateChange.resumed! && _wasEverContinuous) {
      // Message continuity has been lost.
      _reloadAllOnAttach = true;
    }

    if (stateChange.current == ably.ChannelState.attached) {
      _wasEverContinuous = true;

      if (_reloadAllOnAttach) {
        _serverSentEventsCubit.reload();
        _reloadAllOnAttach = false;
      }
    }
  }

  void _onMessage(ably.Message message) async {
    print("New Ably message arrived ${message.name}");

    try {
      final decryptedBytes = decryptAes256Cbc(
        message.data as Uint8List,
        credentials.encryptionKey,
        Uint8List.fromList('CoursePlease.com'.codeUnits),
      );
      final decryptedString = String.fromCharCodes(decryptedBytes);
      print("Decrypted $decryptedString");

      final sse = ServerSentEvent.fromMap(jsonDecode(decryptedString));
      _serverSentEventsCubit.applyEvents([sse]);
    } catch (_) {
      // TODO: Log the error.
      print("Cannot decrypt the message! Reloading the actor the state.");
      await _authenticationCubit.reloadCurrentActor();
      _serverSentEventsCubit.reload();
    }
  }

  @override
  void dispose() async {
    await _channelMessageSubscription?.cancel();
    await _channel?.detach();
    await _realtime?.connection.close();
    super.dispose();
  }
}

class AblyNativeProtocolCubitFactory extends RealtimeFactoryInterface {
  @override
  AbstractRealtimeCubit? createIfValid(RealtimeCredentials credentials) {
    return AblyNativeProtocolCubit(credentials: credentials);
  }
}
