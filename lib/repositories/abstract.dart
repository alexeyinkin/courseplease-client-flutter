import 'dart:convert';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:http/http.dart' as http;

class ListLoadResult<T> {
  final List<T> objects;
  final String? nextPageToken;

  ListLoadResult(this.objects, this.nextPageToken);

  bool hasMore() {
    return nextPageToken != null;
  }
}

abstract class AbstractRepository<I, O extends WithId<I>> {
  Future<List<O>> loadAll() {
    throw UnimplementedError();
  }

  Future<O?> loadById(I id) {
    throw UnimplementedError();
  }

  Future<List<O>> loadByIds(List<I> ids) {
    throw UnimplementedError();
  }
}

abstract class AbstractFilteredRepository<
  I,
  O extends WithId<I>,
  F extends AbstractFilter
> extends AbstractRepository<I, O> {
  Future<ListLoadResult<O>> loadWithFilter(F filter, String? pageToken);
}

@Deprecated('Use ApiClient for network operations.')
class NetworkMapDataProvider {
  Future<ListLoadResult<Map<String, dynamic>>> loadList(Uri uri, String? pageToken) {
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
        .get(uri, headers: _getHeaders())
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

  Map<String, String> _getHeaders() {
    return {};
  }
}
