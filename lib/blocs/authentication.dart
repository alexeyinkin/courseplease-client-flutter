import 'dart:async';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/router/secure_storage_keys_enum.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends Bloc {
  static const oauthTempKeyLength = 64;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _secureStorage = GetIt.instance.get<FlutterSecureStorage>();

  final initialState = AuthenticationState.notLoadedFromStorage();

  var _authenticationState = AuthenticationState.notLoadedFromStorage();
  AuthenticationState get currentState => _authenticationState;

  final _outStateController = BehaviorSubject<AuthenticationState>();
  Stream<AuthenticationState> get outState => _outStateController.stream;

  AuthenticationBloc() {
    _setState(initialState);
    _init();
  }

  Future<void> _init() async {
    final key = await _loadDeviceKey();

    if (key == null) {
      await _setFreshState(); // Will get and store the key.
    } else {
      await _testDeviceKey(key);
    }
  }

  Future<void> requestAuthorization(
    BuildContext context,
    AuthProvider provider,
  ) async {
    if (!await _canRequestAuthorization()) return;

    _setState(AuthenticationState.requested(_authenticationState));
    try {
      await provider.authenticate(context);
    } catch (e) {
      // User has closed the popup. Or something else happened.
      // No handling. Just check the device key to get to a known state.
    }

    await _testDeviceKey(_authenticationState.deviceKey!);
  }

  Future<bool> _canRequestAuthorization() async {
    if (_authenticationState.deviceKey == null) {
      await _retryFailedDeviceTest();

      if (_authenticationState.deviceKey == null) {
        print('Failed to get device key. Cannot authenticate.');
        return false;
      }
    }

    switch (_authenticationState.status) {
      case AuthenticationStatus.deviceKey:
        return true;
      default:
        return false;
    }
  }

  void signOut() async {
    _setFreshState();
  }

  Future<String?> _loadDeviceKey() async {
    return _secureStorage.read(key: SecureStorageKeysEnum.deviceKey);
  }

  Future<void> _setFreshState() async {
    _apiClient.setDeviceKey(null);
    _setState(AuthenticationState.fresh());

    try {
      await _registerDevice();
    } catch (e) {
      _setDeviceKeyFailedState();
    }
  }

  void _storeDeviceKey(String key) {
    _secureStorage.write(key: SecureStorageKeysEnum.deviceKey, value: key);
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

  Future<void> _registerDevice() async {
    try {
      final response = await _apiClient.registerDevice(
        await _createRegisterDeviceRequest(),
      );

      _storeDeviceKey(response.key);
      _apiClient.setDeviceKey(response.key);

      _setState(
        AuthenticationState.deviceKey(response.key),
      );
    } on UnsupportedError catch (ex) {
      print(ex.toString());
      print(ex.stackTrace);
      _setDeviceKeyFailedState();
    }
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

  Future<void> _testDeviceKey(String deviceKey) async {
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

  Future<void> _retryFailedDeviceTest() async {
    _setState(initialState);
    await _init();
  }

  Future<void> reloadCurrentActor() async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    _testDeviceKey(deviceKey);
  }

  Future<void> saveProfile(SaveProfileRequest request) async {
    final deviceKey = _authenticationState.deviceKey;
    if (deviceKey == null) throw Exception('deviceKey is required for this');

    final me = await _apiClient.saveProfile(request);
    _setMe(me, deviceKey);
  }

  Future<void> saveConsultingProduct(
    SaveConsultingProductRequest request,
  ) async {
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

int? getCurrentUserId() {
  final cubit = GetIt.instance.get<AuthenticationBloc>();
  return cubit.currentState.data?.user?.id;
}
