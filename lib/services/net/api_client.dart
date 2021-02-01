import 'dart:convert';
import 'dart:io';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'package:meta/meta.dart';

class ApiClient {
  final String host = 'courseplease.com';
  static const _authorizationHeader = 'Authorization';

  String _deviceKey; // Nullable.
  String _lang;

  void setDeviceKey(String deviceKey) { // Nullable.
    _deviceKey = deviceKey;
  }

  void setLang(String lang) {
    _lang = lang;
  }

  Future<RegisterDeviceResponseData> registerDevice(RegisterDeviceRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/auth/registerDevice',
      body: request,
    );
    return RegisterDeviceResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> getMe(String overrideDeviceKey) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.get,
      path: '/api1/me',
      headers: {_authorizationHeader: _getBearerAuthorizationHeaderValue(overrideDeviceKey)},
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<CreateOAuthTempTokenResponseData> createOAuthTempToken(CreateOAuthTempTokenRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/auth/createOAuthTempToken',
      body: request,
    );
    return CreateOAuthTempTokenResponseData.fromMap(mapResponse.data);
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getAllEntities(String name) async {
    return _createListLoadResultResponse(
      await sendRequest(
        method: HttpMethod.get,
        path: '/api1/{@lang}/gallery/' + name,
      ),
    );
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getEntities(
    String name,
    Map<String, String> filter,
    String pageToken,
  ) async {
    return _createListLoadResultResponse(
      await sendRequest(
        method: HttpMethod.get,
        path: '/api1/{@lang}/gallery/' + name,
        queryParameters: _paramsWithPageToken(filter, pageToken),
      ),
    );
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> getEntity<I>(
    String name,
    I id,
  ) async {
    return await sendRequest(
      method: HttpMethod.get,
      path: '/api1/{@lang}/gallery/' + name + '/' + id.toString(),
    );
  }

  SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>> _createListLoadResultResponse(SuccessfulApiResponse<Map<String, dynamic>> mapResponse) {
    return SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>(
      data: _createListLoadResult(mapResponse.data),
    );
  }

  ListLoadResult<Map<String, dynamic>> _createListLoadResult(Map<String, dynamic> dataMap) {
    final items = dataMap['items'].cast<Map<String, dynamic>>();
    final nextPageToken = dataMap['nextPageToken'];

    return ListLoadResult(items, nextPageToken);
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> sendRequest({
    @required HttpMethod method,
    @required String path,
    Map<String, String> queryParameters,
    Map<String, String> headers, // Nullable.
    RequestBody body,
  }) async {
    if (headers == null) headers = Map<String, String>();

    final responseMap = await sendMap(
      method: method,
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      body: body?.toJson(),
    );

    final int status = responseMap['status'];

    if (status != 1) {
      throw ErrorApiResponse(status: status, message: responseMap['message']);
    }

    return SuccessfulApiResponse(data: responseMap['data']);
  }

  Future<Map<String, dynamic>> sendMap({
    @required HttpMethod method,
    @required String path,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    final headersWithContentType = Map<String, String>();
    headersWithContentType.addAll(headers);
    headersWithContentType['Content-Type'] = ContentType.json.toString();
    
    final responseString = await sendString(
      method: method,
      path: path,
      queryParameters: queryParameters,
      headers: headersWithContentType,
      body: jsonEncode(body),
    );

    final map = jsonDecode(responseString);
    return map;
  }

  Future<String> sendString({
    @required HttpMethod method,
    @required String path,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String body,
  }) async {
    final uri = _createUri(path: path, queryParameters: queryParameters);
    http.Response response;

    if (_deviceKey != null && !headers.containsKey(_authorizationHeader)) {
      headers = mapWithEntry(headers, _authorizationHeader, _getBearerAuthorizationHeaderValue(_deviceKey));
    }

    switch (method) {
      case HttpMethod.get:
        response = await http.get(uri, headers: headers);
        break;
      case HttpMethod.post:
        response = await http.post(uri, headers: headers, body: body);
        break;
    }

    if (response.statusCode != 200) {
      throw HttpException(response.body, uri: uri);
    }

    return response.body;
  }

  Uri _createUri({
    @required String path,
    Map<String, String> queryParameters,
  }) {
    path = path.replaceFirst('{@lang}', _lang);
    return Uri.https(host, path, queryParameters);
  }

  String _getBearerAuthorizationHeaderValue(String token) {
    return 'Bearer ' + token;
  }

  Map<String, String> _paramsWithPageToken(Map<String, String> queryParams, String pageToken) { // Nullable
    return pageToken == null
        ? queryParams
        : mapWithEntry(queryParams, 'pageToken', pageToken);
  }
}

enum HttpMethod {
  get,
  post,
}

abstract class RequestBody {
  Map<String, dynamic> toJson();
}

abstract class ApiResponse {
  final int status;

  ApiResponse({
    @required this.status,
  });
}

class SuccessfulApiResponse<T> extends ApiResponse {
  final T data;

  SuccessfulApiResponse({
    @required this.data,
  }) : super(status: 1);
}

class ErrorApiResponse extends ApiResponse {
  final String message;

  ErrorApiResponse({
    @required int status,
    @required this.message,
  }) : super(status: status);
}

class RegisterDeviceRequest extends RequestBody {
  final AppInfo appInfo;
  final DeviceInfoForServer deviceInfo;

  RegisterDeviceRequest({
    @required this.appInfo,
    @required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'appInfo': appInfo.toJson(),
      'deviceInfo': deviceInfo.toJson(),
    };
  }
}

class RegisterDeviceResponseData {
  final String key;

  RegisterDeviceResponseData._({
    @required this.key,
  });

  factory RegisterDeviceResponseData.fromMap(Map<String, dynamic> map) {
    return RegisterDeviceResponseData._(key: map['key']);
  }
}

class MeResponseData {
  final String deviceStatus; // Nullable.
  final User user; // Nullable.

  MeResponseData._({
    @required this.deviceStatus,
    @required this.user,
  });

  factory MeResponseData.fromMap(Map<String, dynamic> map) {
    final userMap = map['user'];

    return MeResponseData._(
      deviceStatus: map['deviceStatus'],
      user: userMap == null ? null : User.fromMap(userMap),
    );
  }
}

class CreateOAuthTempTokenRequest extends RequestBody {
  final int providerId;

  CreateOAuthTempTokenRequest({
    @required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
    };
  }
}

class CreateOAuthTempTokenResponseData {
  final String key;

  CreateOAuthTempTokenResponseData._({
    @required this.key,
  });

  factory CreateOAuthTempTokenResponseData.fromMap(Map<String, dynamic> map) {
    return CreateOAuthTempTokenResponseData._(key: map['key']);
  }
}