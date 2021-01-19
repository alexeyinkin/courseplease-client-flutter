import 'dart:convert';
import 'dart:io';

import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:http/http.dart' as http;

class ListLoadResult<T> {
  final List<T> objects;
  final String nextPageToken; // Nullable

  ListLoadResult(this.objects, this.nextPageToken);

  bool hasMore() {
    return nextPageToken != null;
  }
}

abstract class AbstractRepository<I, O extends WithId<I>> {
  Future<List<O>> loadAll();
  Future<O> loadById(I id);
  Future<List<O>> loadByIds(List<I> ids);
}

abstract class AbstractFilteredRepository<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> extends AbstractRepository<I, O> {
  Future<ListLoadResult<O>> loadWithFilter(F filter, String pageToken);
}

@Deprecated('Use ApiClient for network operations.')
class NetworkMapDataProvider {
  Future<ListLoadResult<Map<String, dynamic>>> loadList(Uri uri, String pageToken) {
    if (pageToken != null) {
      final paramsClone = Map<String, String>.from(uri.queryParameters);
      paramsClone['pageToken'] = pageToken;

      uri = Uri.https(
        uri.authority,
        uri.path,
        paramsClone,
      );
    }

    return http
        .get(uri.toString(), headers: _getHeaders())
        .then(_parseListResponse);
  }

  ListLoadResult<Map<String, dynamic>> _parseListResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch.');
    }

    return _parseListString(response.body);
  }

  ListLoadResult<Map<String, dynamic>> _parseListString(String str) {
    final map = jsonDecode(str);
    final items = map['data']['items'].cast<Map<String, dynamic>>();
    final nextPageToken = map['data']['nextPageToken'];

    return ListLoadResult(items, nextPageToken);
  }

  Future<Map<String, dynamic>> getSingle(String url) {
    return http
        .get(url, headers: _getHeaders())
        .then(_parseSingleResponse);
  }

  Future<Map<String, dynamic>> postSingle(String url, Map<String, dynamic> body) {
    final headers = _getHeaders();
    headers['Content-Type'] = ContentType.json.toString();

    return http
        .post(url, headers: headers, body: jsonEncode(body))
        .then(_parseSingleResponse);
  }

  Map<String, String> _getHeaders() {
    return {};
  }

  Map<String, dynamic> _parseSingleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch.');
    }

    return _parseSingleString(response.body);
  }

  Map<String, dynamic> _parseSingleString(String str) {
    var map = jsonDecode(str);
    return map['data'] as Map<String, dynamic>; // Nullable
  }
}
