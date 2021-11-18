import 'dart:convert';
import 'dart:io';

import 'package:ably_flutter/ably_flutter.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class AblyTokenProvider {
  final _apiClient = GetIt.instance.get<ApiClient>();

  Future<TokenDetails?> getAuthToken() async {
    final tokenRequestMap = await _getAuthTokenRequest();
    if (tokenRequestMap == null) return null;

    final uri = Uri.https(
      'rest.ably.io',
      '/keys/' + tokenRequestMap['keyName']! + '/requestToken',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(uri, headers: headers, body: jsonEncode(tokenRequestMap));

    if (response.statusCode ~/ 100 != 2) {  // Any 2xx will do. 201 comes at the time.
      throw HttpException(response.body, uri: uri);
    }

    final tokenMap = jsonDecode(response.body);
    return TokenDetails.fromMap(tokenMap);
  }

  Future<Map<String, dynamic>?> _getAuthTokenRequest() async {
    final meResponseData = await _apiClient.getMe();
    final tokenRequestJson = meResponseData.realtimeCredentials?.providerToken;

    if (tokenRequestJson == null) {
      print('Returning null token request for Ably.');
      return null;
    }

    final tokenRequestMap = jsonDecode(tokenRequestJson);
    print('Returning valid token request for Ably.');
    return tokenRequestMap;
  }
}
