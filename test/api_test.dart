import 'dart:io';
import 'package:server_example/handlers/static_files.dart';
import 'package:server_example/middleware/authentication.dart';
import 'package:server_example/routes/route_service.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

void main() {
  HttpServer server;
  http.Client httpClient;
  Uri url;
  setUp(() async {
    final routeService = RouteService();
    var cascadeHandler = shelf.Cascade()
        .add(routeService.handler)
        .add(staticFileHandler)
        .handler;
    var handler = const shelf.Pipeline()
        .addMiddleware(shelf.logRequests())
        .addMiddleware(authenticationHandler)
        .addHandler(cascadeHandler);

    server = await io.serve(handler, 'localhost', 8080);
    url = Uri.parse('http://${server.address.host}:${server.port}');
    httpClient = http.Client();
  });
  tearDown(() async {
    httpClient.close();
    await server.close(force: true);
    server = null;
    url = null;
  });
  test('testing login route cooking setting /api/login ', () async {
    final request =
        http.MultipartRequest('POST', url.replace(path: '/api/login'))
          ..fields['fname'] = 'ramyak';
    final response = await httpClient.send(request);
    expect(response.statusCode, 302);
    expect(response.headers.containsKey(HttpHeaders.cookieHeader), false);
    expect(
        response.headers[HttpHeaders.setCookieHeader].contains('name=ramyak'),
        true);
  });

  test('test greetings without authentication /api/messages', () async {
    final response = await httpClient.get(url.replace(path: '/api/messages'));
    expect(response.statusCode, 200);
    expect(response.body,
        '{"message":"Greetings null","note":"Non authenticated request"}');
  });
  test('test greetings with authentication /api/messages', () async {
    final response = await httpClient.get(url.replace(path: '/api/messages'),
        headers: {HttpHeaders.cookieHeader: 'name=ramyak'});
    expect(response.statusCode, 200);
    expect(response.body,
        '{"message":"Greetings ramyak","note":"The name of the person was read using cookies"}');
  });
}
