import 'dart:io' show HttpHeaders;
import 'package:server_example/handlers/landing/landing.dart';
import 'package:server_example/routes/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

///Default router service. All requests first comes here.
class RouteService {
  Handler get handler {
    final router = Router();
    router.get('/', indexLandingHandler);

    router.get('/wave', (Request request) async {
      return Response.ok('_o/');
    });
    router.get('/authenticated', (Request request) {
      var headers = request.headers;
      if (!headers.containsKey(HttpHeaders.cookieHeader)) {
        return Response.forbidden('You are not allowed to view this request');
      }
      return Response.ok('content');
    });

    router.mount('/api/', Api().router);
    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}
