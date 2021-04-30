class NetworkRequestInfo {
  final String method;
  final String url;

  NetworkRequestInfo({
    required this.method,
    required this.url,
  });

  factory NetworkRequestInfo.fromMap(Map<String, dynamic> map) {
    return NetworkRequestInfo(
      method: map['method'],
      url:    map['url'],
    );
  }

  static NetworkRequestInfo? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null
        ? null
        : NetworkRequestInfo.fromMap(map);
  }
}
