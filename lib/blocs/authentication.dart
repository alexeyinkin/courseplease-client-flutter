import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/auth/auth_provider.dart';
import 'package:courseplease/models/auth/facebook_auth_provider.dart';
import 'package:courseplease/models/auth/instagram_auth_provider.dart';
import 'package:courseplease/models/auth/vk_auth_provider.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends Bloc{
  static const oauthTempKeyLength = 64;
  static const _deviceKeyKey = 'deviceKey';

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _secureStorage = FlutterSecureStorage();
  final _oauthTempTokens = Map<String, String>();

  final _providers = <AuthProvider>[
    FacebookAuthProvider(id: 7, appId: '686805814840335', redirectHostAndPort: AuthProvider.defaultProductionHostAndPort),
    InstagramAuthProvider(id: 24, appId: '314996693237774', redirectHostAndPort: AuthProvider.defaultProductionHostAndPort),
    VkAuthProvider(id: 8, appId: '7413348', redirectHostAndPort: AuthProvider.defaultProductionHostAndPort),
    // AuthProvider(color: Color(0xFFEA4335), intName: 'google', title: 'Google'),
  ];

  final initialState = AuthenticationState(status: AuthenticationStatus.notLoadedFromStorage);

  var _authenticationState = AuthenticationState(status: AuthenticationStatus.notLoadedFromStorage);

  final _inEventController = StreamController<AuthenticationEvent>();
  Sink<AuthenticationEvent> get inEvent => _inEventController.sink;

  final _outProvidersController = BehaviorSubject<List<AuthProvider>>();
  Stream<List<AuthProvider>> get outProviders => _outProvidersController.stream;

  final _outStateController = BehaviorSubject<AuthenticationState>();
  Stream<AuthenticationState> get outState => _outStateController.stream;

  AuthenticationBloc() {
    _outProvidersController.sink.add(_providers);
    _setState(initialState);
    _init();
  }

  void _init() async {
    final key = await _loadDeviceKey();

    if (key == null) {
      _setFreshState(); // Will get and store the key.
    } else {
      _testDeviceKey(key);
    }

    _inEventController.stream.listen(_handleEvent);
  }

  void _handleEvent(AuthenticationEvent event) {
    if (event is RequestAuthorizationEvent) {
      _handleRequestAuthorizationEvent(event as RequestAuthorizationEvent);
    }
  }

  void _handleRequestAuthorizationEvent(RequestAuthorizationEvent event) async {
    final request = CreateOAuthTempTokenRequest(provider: event.provider.intName);
    final tempToken = await _apiClient.createOAuthTempToken(request);
    _oauthTempTokens[event.provider.intName] = tempToken.key;

    // if (_authenticationState.status != AuthenticationStatus.notAuthenticated) {
    //   throw Exception('Should not happen');
    // }

    _requestAuthentication(event.provider, tempToken.key, event.context);
  }

  void _requestAuthentication(AuthProvider provider, String oauthTempToken, BuildContext context) async {
    final stateAssoc = {
      'key': 'oauthTempToken',
      'host': AuthProvider.defaultProductionHostAndPort,
    };
    final state = jsonEncode(stateAssoc);
    final uri = provider.getOauthUrl(state);

    final routeFuture = Navigator.of(context).pushNamed(
      SignInWebviewScreen.routeName,
      arguments: SignInWebviewArguments(uri: uri),
    );
  }

  void _registerOauthTempKey(String key) {
    // TODO: Register at courseplease.com server.
  }

  Future<String> _loadDeviceKey() async { // Nullable.
    return _secureStorage.read(key: _deviceKeyKey);
  }

  void _setFreshState() {
    _setState(
      AuthenticationState(status: AuthenticationStatus.fresh),
    );
    _registerDevice()
        .catchError((_) => _setDeviceKeyFailedState());
  }

  void _storeDeviceKey(String key) {
    _secureStorage.write(key: _deviceKeyKey, value: key);
  }

  void _setDeviceKeyFailedState() {
    print('Failed to get device key!');
    _setState(
      AuthenticationState(status: AuthenticationStatus.deviceKeyFailed),
    );
  }

  void _setState(AuthenticationState state) {
    _authenticationState = state;
    _outStateController.sink.add(state);
  }

  Future<RegisterDeviceResponseData> _registerDevice() async {
    final response = await _apiClient.registerDevice(await _createRegisterDeviceRequest());
    _storeDeviceKey(response.key);
    _apiClient.setDeviceKey(response.key);

    _setState(
      AuthenticationState(status: AuthenticationStatus.deviceKey, deviceKey: response.key),
    );

    return response;
  }

  Future<RegisterDeviceRequest> _createRegisterDeviceRequest() async {
    final appInfo = await AppInfo.getCurrent();
    final deviceInfo = await DeviceInfo.getCurrent();
    final deviceInfoForServer = DeviceInfoForServer.fromDeviceInfo(deviceInfo);

    return RegisterDeviceRequest(
      appInfo: appInfo,
      deviceInfo: deviceInfoForServer,
    );
  }

  void _testDeviceKey(String deviceKey) async {
    final me = await _apiClient.getMe(deviceKey);

    if (me.deviceStatus == null) {
      _setState(AuthenticationState(status: AuthenticationStatus.deviceKeyFailed));
    } else {
      _apiClient.setDeviceKey(deviceKey);
      _setState(AuthenticationState(status: AuthenticationStatus.deviceKey));
    }
  }

  @override
  void dispose() {
    _inEventController.close();
    _outProvidersController.close();
  }
}

class AuthenticationState {
  final AuthenticationStatus status;
  final String deviceKey; // Nullable

  AuthenticationState({
    @required this.status,
    this.deviceKey,
  });
}

enum AuthenticationStatus {
  /// Not yet tried to read status from storage.
  notLoadedFromStorage,

  /// Nothing in the storage. Requested to register the device on server, awaiting the key.
  fresh,

  /// Registered the device on server and got the key. Saving or saved in in the storage.
  /// Still anonymous.
  deviceKey,

  /// Navigated to OAuth provider, awaiting the response.
  requested,

  authenticated,

  /// Could not connect to the server to register device.
  /// TODO: Allow to retry after some time or on each data request.
  deviceKeyFailed,
}

abstract class AuthenticationEvent {}

class RequestAuthorizationEvent extends AuthenticationEvent {
  final AuthProvider provider;
  final BuildContext context;

  RequestAuthorizationEvent({
    @required this.provider,
    @required this.context,
  });
}
