import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

/// This server listens to redirects from providers such as Facebook or Google,
/// grabs and returns code to be exchanged for access_token.
class OAuthCodeHttpServer {
  final String host;
  final int port;
  final String response;

  StreamController<String> _codeStreamController; // Nullable
  HttpServer _server; // Nullable.

  OAuthCodeHttpServer({
    @required this.host,
    @required this.port,
    @required this.response,
  });

  static Future<OAuthCodeHttpServer> setUp({
    String host = 'localhost',
    @required int port,
    String response = "<html><h1>You can now close this window</h1></html>", // TODO: Localize.
  }) async {
    final instance = OAuthCodeHttpServer(host: host, port: port, response: response);
    await instance._setUp();
    return instance;
  }

  Future<Null> _setUp() async {
    if (_codeStreamController != null) {
      throw Exception('This can only be used once per instance.');
    }

    _codeStreamController = new StreamController();

    //_server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _server = await HttpServer.bindSecure(InternetAddress.loopbackIPv4, port, SecurityContext.defaultContext);
    _server.listen(_onRequest);
  }

  Future<String> getCodeFuture() {
    return _codeStreamController.stream.first;
  }

  void _onRequest(HttpRequest request) async {
    final String code = request.uri.queryParameters['code'];

    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.html.mimeType)
      ..write(response);

    await request.response.close();
    await shutdown();
    _codeStreamController.sink.add(code);
    await _codeStreamController.close();
  }

  Future<Null> shutdown() async {
    await _server.close(force: true);
  }
}
