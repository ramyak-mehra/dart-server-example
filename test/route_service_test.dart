import 'dart:io';
import 'package:server_example/handlers/landing/landing.dart';
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

  test('testing html response  / ', () async {
    final response = await httpClient.get(
      url,
    );
    expect(response.statusCode, 200);
    final landingHtml = await renderLandingPage();
    expect(response.body, landingHtml);
  });
  test('testing change text button response  / ', () async {
    final response = await httpClient.get(
      url,
    );
    expect(response.statusCode, 200);
    final currentDirectory = Directory.current;
    final clickedResponse = await File(
            '${currentDirectory.path}/test/html_files/landing_clicked.html')
        .readAsString();
    expect(response.body, clickedResponse);
  });

  test('testing route cookie present /autneticated ', () async {
    final response = await httpClient.get(url.replace(path: '/authenticated'),
        headers: {HttpHeaders.cookieHeader: 'name=ramyak'});
    expect(response.statusCode, 200);
    expect(response.body, 'content');
    expect(response.headers[HttpHeaders.contentTypeHeader],
        'text/plain; charset=utf-8');
  });
  test('testing route without cookie present /autneticated ', () async {
    final response = await httpClient.get(
      url.replace(path: '/authenticated'),
    );
    expect(response.statusCode, 403);
    expect(response.body, 'You are not allowed to view this request');
    expect(response.headers[HttpHeaders.contentTypeHeader],
        'text/plain; charset=utf-8');
  });
}
