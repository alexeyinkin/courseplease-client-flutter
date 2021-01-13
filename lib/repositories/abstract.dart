import 'dart:convert';

import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:http/http.dart' as http;

class LoadResult<T> {
  final List<T> objects;
  final String nextPageToken; // Nullable

  LoadResult(this.objects, this.nextPageToken);

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
  Future<LoadResult<O>> loadWithFilter(F filter, String pageToken);
}

// TODO: Move to a separate data provider layer. Learn where it fits.
class NetworkMapDataProvider {
  Future<LoadResult<Map<String, dynamic>>> loadList(Uri uri, String pageToken) {
    if (pageToken != null) {
      final paramsClone = Map<String, String>.from(uri.queryParameters);
      paramsClone['pageToken'] = pageToken;

      uri = Uri.https(
        uri.authority,
        uri.path,
        paramsClone,
      );
    }

    return http.get(uri.toString()).then(_parseListResponse);
  }

  LoadResult<Map<String, dynamic>> _parseListResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch.');
    }

    return _parseListString(response.body);
  }

  LoadResult<Map<String, dynamic>> _parseListString(String str) {
    final map = jsonDecode(str);
    final items = map['data']['items'].cast<Map<String, dynamic>>();
    final nextPageToken = map['data']['nextPageToken'];

    return LoadResult(items, nextPageToken);
  }

  Future<Map<String, dynamic>> loadSingle(String url) {
    return http.get(url).then(_parseSingleResponse);
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
