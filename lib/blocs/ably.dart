import 'dart:async';
import 'dart:convert';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/realtime_factory.dart';
import 'package:courseplease/blocs/server_sent_events.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

class AblySseCubit extends Bloc {
  final RealtimeCredentials credentials;
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _serverSentEventsCubit = GetIt.instance.get<ServerSentEventsCubit>();

  ably.Realtime? _realtime;
  ably.RealtimeChannel? _channel;
  Stream<ably.Message>? _messageStream;
  StreamSubscription? _channelMessageSubscription;
  bool _wasEverContinuous = false;
  bool _reloadAllOnAttach = false;

  AblySseCubit({
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

  Future<ably.TokenRequest?> _getAuthToken(ably.TokenParams params) async {
    final meResponseData = await _apiClient.getMe();
    final tokenRequestJson = meResponseData.realtimeCredentials?.providerToken;

    if (tokenRequestJson == null) {
      print('COURSEPLEASE: Returning null token request.');
      return null;
    }

    final tokenRequestMap = jsonDecode(tokenRequestJson);
    final tokenRequest = ably.TokenRequest.fromMap(tokenRequestMap);
    print('COURSEPLEASE: Returning valid token request.');
    return tokenRequest;
  }

  void _onStateChange(ably.ConnectionStateChange stateChange) {
    print('Ably realtime connection state changed: ${stateChange.event}');
  }

  String _getChannelName() {
    return 'sse-v1-' + credentials.crossDeviceToken;
  }

  void _onChannelStateChange(ably.ChannelStateChange stateChange) {
    print("Ably channel state changed: ${stateChange.current}");

    if (!stateChange.resumed && _wasEverContinuous) {
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

  void _onMessage(ably.Message message) {
    print("New Ably message arrived ${message.data}");
    final sse = ServerSentEvent.fromMap(jsonDecode(message.data.toString()));

    _serverSentEventsCubit.applyEvents([sse]);
  }

  @override
  void dispose() async {
    await _channelMessageSubscription?.cancel();
    await _channel?.detach();
    await _realtime?.connection.close();
  }
}

class AblySseCubitFactory extends RealtimeFactoryInterface {
  @override
  Bloc? createIfValid(RealtimeCredentials credentials) {
    return AblySseCubit(credentials: credentials);
  }
}
