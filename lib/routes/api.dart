import 'dart:io' show HttpHeaders;
import 'package:server_example/response_utility.dart';
import 'package:server_example/utility.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Api {
  Future<Response> _messages(Request request) async {
    if (request.context.containsKey('custom.user')) {
      var user = request.context['custom.user'] as String;
      user = user.replaceAll('name=', '');

      return jsonResponse({
        'message': 'Greetings $user',
        'note': 'The name of the person was read using cookies'
      });
    } else {
      return jsonResponse(
          {'message': 'Greetings null', 'note': 'Non authenticated request'});
    }
  }

  Future<Response> _login(Request request) async {
    try {
      if (request.headers.containsKey(HttpHeaders.cookieHeader)) {
        if (request.headers[HttpHeaders.cookieHeader].contains('name=')) {
          return Response.found('/authenticated');
        }
      }
      var body = await handlePostRequest(request);
      var headers = {
        HttpHeaders.setCookieHeader:
            'name=${body['fname']};path=/;SameSite=Lax;Expires=${DateTime.now().add(Duration(days: 1))}'
      };
      return Response.found('/authenticated', headers: headers);
    } catch (e) {
      return Response.notFound('Invalid request');
    }
  }

  Router get router {
    final router = Router();
    router.get('/messages', _messages);
    router.get('/messages/', _messages);
    router.post('/login', _login);
    router.post('/login/', _login);
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));
    return router;
  }
}
