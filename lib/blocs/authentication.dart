import 'dart:async';
import 'dart:convert';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/auth/auth_provider.dart';
import 'package:courseplease/models/auth/facebook_auth_provider.dart';
import 'package:courseplease/models/auth/instagram_auth_provider.dart';
import 'package:courseplease/models/auth/vk_auth_provider.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/screens/sign_in_webview/sign_in_webview.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
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

  final initialState = AuthenticationState.notLoadedFromStorage();

  var _authenticationState = AuthenticationState.notLoadedFromStorage();
  AuthenticationState get currentState => _authenticationState;

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
  }

  void requestAuthorization(AuthProvider provider, BuildContext context) async {
    _setState(AuthenticationState.requested(_authenticationState));

    final request = CreateOAuthTempTokenRequest(providerId: provider.id);
    final tempToken = await _apiClient.createOAuthTempToken(request);
    _oauthTempTokens[provider.intName] = tempToken.key;

    _requestAuthorization(provider, tempToken.key, context);
  }

  void _requestAuthorization(AuthProvider provider, String oauthTempToken, BuildContext context) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final stateAssoc = {
      'key': oauthTempToken,
      'host': AuthProvider.defaultProductionHostAndPort,
    };
    final state = jsonEncode(stateAssoc);
    final uri = provider.getOauthUrl(state);

    await SignInWebviewScreen.show(
      context: context,
      uri: uri,
    );

    _testDeviceKey(deviceKey);
  }

  void signOut() async {
    _setFreshState();
  }

  Future<String?> _loadDeviceKey() async {
    return _secureStorage.read(key: _deviceKeyKey);
  }

  void _setFreshState() {
    _apiClient.setDeviceKey(null);
    _setState(AuthenticationState.fresh());
    _registerDevice()
        .catchError((_) => _setDeviceKeyFailedState());
  }

  void _storeDeviceKey(String key) {
    _secureStorage.write(key: _deviceKeyKey, value: key);
  }

  void _setDeviceKeyFailedState() {
    print('Failed to get or validate device key!');
    _setState(
      AuthenticationState.deviceKeyFailed(),
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
      AuthenticationState.deviceKey(response.key),
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
    // TODO: Add a state when this check is in progress.

    final me = await _apiClient.getMeByDeviceKey(deviceKey);
    _setMe(me, deviceKey);
  }

  void _setMe(MeResponseData me, String deviceKey) {

    if (me.deviceStatus == null) {
      _setDeviceKeyFailedState();
    } else {
      _apiClient.setDeviceKey(deviceKey);

      if (me.user == null) {
        _setState(AuthenticationState.deviceKey(deviceKey));
      } else {
        _setState(
          AuthenticationState.authenticatedFromResponse(
            deviceKey,
            me,
          ),
        );
      }
    }
  }

  Future<void> reloadCurrentActor() async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    _testDeviceKey(deviceKey);
  }

  void saveProfile(SaveProfileRequest request) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.saveProfile(request);
    _setMe(me, deviceKey);
  }

  Future<void> saveConsultingProduct(SaveConsultingProductRequest request) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.saveConsultingProduct(request);
    _setMe(me, deviceKey);
  }

  Future<void> saveContactParams(SaveContactParamsRequest request) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.saveContactParams(request);
    _setMe(me, deviceKey);
  }

  Future<void> synchronizeProfileSynchronously(int contactId) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.syncProfileSync(contactId);
    _setMe(me, deviceKey);
  }

  Future<void> synchronizeProfilesSynchronously() async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.syncAllProfilesSync();
    _setMe(me, deviceKey);
  }

  @override
  void dispose() {
    _outProvidersController.close();
    _outStateController.close();
  }
}

class AuthenticationState {
  final AuthenticationStatus status;
  final DeviceValidity deviceValidity;
  final String? deviceKey;
  final MeResponseData? data;
  final List<int> teacherSubjectIds;

  AuthenticationState({
    required this.status,
    required this.deviceValidity,
    this.deviceKey,
    this.data,
    this.teacherSubjectIds = const <int>[],
  });

  factory AuthenticationState.notLoadedFromStorage() {
    return AuthenticationState(
      status: AuthenticationStatus.notLoadedFromStorage,
      deviceValidity: DeviceValidity.determining,
    );
  }

  factory AuthenticationState.fresh() {
    return AuthenticationState(
      status: AuthenticationStatus.fresh,
      deviceValidity: DeviceValidity.determining,
    );
  }

  factory AuthenticationState.deviceKey(String deviceKey) {
    return AuthenticationState(
      status: AuthenticationStatus.deviceKey,
      deviceValidity: DeviceValidity.valid,
      deviceKey: deviceKey,
    );
  }

  factory AuthenticationState.requested(AuthenticationState previous) {
    return AuthenticationState(
      status: AuthenticationStatus.requested,
      deviceValidity: DeviceValidity.valid,
      deviceKey: previous.deviceKey,
    );
  }

  factory AuthenticationState.authenticatedFromResponse(
    String deviceKey,
    MeResponseData response,
  ) {
    return AuthenticationState(
      status: AuthenticationStatus.authenticated,
      deviceValidity: DeviceValidity.valid,
      deviceKey: deviceKey,
      data: response,
      teacherSubjectIds: TeacherSubject.getSubjectIds(response.teacherSubjects),
    );
  }

  factory AuthenticationState.deviceKeyFailed() {
    return AuthenticationState(
      status: AuthenticationStatus.deviceKeyFailed,
      deviceValidity: DeviceValidity.invalid,
    );
  }
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

enum DeviceValidity {
  /// Either checking a known device key or registering a new one.
  /// Will resolve to valid or invalid.
  determining,

  valid,

  /// The device key is invalid and no attempt is running to get a valid key.
  /// Will get here if the check at server has failed.
  /// The app will check the status again on restart.
  /// Until then no action is taken.
  /// In future a deemed bad actor might get this status.
  invalid,
}

abstract class AuthenticationEvent {}

class RequestAuthorizationEvent extends AuthenticationEvent {
  final AuthProvider provider;
  final BuildContext context;

  RequestAuthorizationEvent({
    required this.provider,
    required this.context,
  });
}
