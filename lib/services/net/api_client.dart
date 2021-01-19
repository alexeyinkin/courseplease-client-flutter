import 'dart:convert';
import 'dart:io';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:http/http.dart' as http;

import 'package:meta/meta.dart';

class ApiClient {
  final String host = 'courseplease.com';
  String _deviceKey;
  String _lang;

  void setDeviceKey(String deviceKey) {
    _deviceKey = deviceKey;
  }

  void setLang(String lang) {
    _lang = lang;
  }

  Future<RegisterDeviceResponseData> registerDevice(RegisterDeviceRequest request) async {
    final mapResponse = await postRequest(path: '/api1/auth/registerDevice', body: request);
    return RegisterDeviceResponseData.fromMap(mapResponse.data);
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getAllEntities(String name) async {
    return _createListLoadResultResponse(
      await getRequest(path: '/api1/{@lang}/gallery/' + name),
    );
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getEntities(
    String name,
    Map<String, String> filter,
    String pageToken,
  ) async {
    return _createListLoadResultResponse(
      await getRequest(
        path: '/api1/{@lang}/gallery/' + name,
        queryParameters: _paramsWithPageToken(filter, pageToken),
      ),
    );
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> getEntity<I>(
    String name,
    I id,
  ) async {
    return await getRequest(
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

  Future<SuccessfulApiResponse<Map<String, dynamic>>> postRequest({
    String path,
    Map<String, String> headers, // Nullable.
    RequestBody body,
  }) async {
    if (headers == null) headers = Map<String, String>();

    final responseMap = await postMap(
      path: path,
      headers: headers,
      body: body.toJson(),
    );

    final int status = responseMap['status'];

    if (status != 1) {
      throw ErrorApiResponse(status: status, message: responseMap['message']);
    }

    return SuccessfulApiResponse(data: responseMap['data']);
  }

  Future<Map<String, dynamic>> postMap({
    String path,
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) async {
    final headersWithContentType = Map<String, String>();
    headersWithContentType.addAll(headers);
    headersWithContentType['Content-Type'] = ContentType.json.toString();
    
    final responseString = await postString(
      path: path,
      headers: headersWithContentType,
      body: jsonEncode(body),
    );

    final map = jsonDecode(responseString);
    return map;
  }

  Future<String> postString({
    @required String path,
    Map<String, String> headers,
    String body,
  }) async {
    final uri = _createUri(path: path);
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw HttpException(response.body, uri: uri);
    }

    return response.body;
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> getRequest({
    String path,
    Map<String, String> queryParameters,
    Map<String, String> headers, // Nullable
  }) async {
    if (headers == null) headers = Map<String, String>();

    final responseMap = await getMap(
      path: path,
      queryParameters: queryParameters,
      headers: headers,
    );

    final int status = responseMap['status'];

    if (status != 1) {
      throw ErrorApiResponse(status: status, message: responseMap['message']);
    }

    return SuccessfulApiResponse(data: responseMap['data']);
  }

  Future<Map<String, dynamic>> getMap({
    String path,
    Map<String, String> queryParameters,
    Map<String, String> headers,
  }) async {
    final headersWithContentType = Map<String, String>();
    headersWithContentType.addAll(headers);
    headersWithContentType['Content-Type'] = ContentType.json.toString();

    final responseString = await getString(
      path: path,
      queryParameters: queryParameters,
      headers: headersWithContentType,
    );

    final map = jsonDecode(responseString);
    return map;
  }

  Future<String> getString({
    @required String path,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String body,
  }) async {
    final uri = _createUri(path: path, queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);

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

  Map<String, String> _paramsWithPageToken(Map<String, String> queryParams, String pageToken) { // Nullable
    return pageToken == null
        ? queryParams
        : mapWithEntry(queryParams, 'pageToken', pageToken);
  }
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
