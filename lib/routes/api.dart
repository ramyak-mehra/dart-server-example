import 'dart:io' show HttpHeaders;
import 'package:intl/intl.dart';
import 'package:server_example/response_utility.dart';
import 'package:server_example/utility.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Api {
  ///Returns a json response {Greetings : <user_name>}.
  ///the user_name comes from the custom.user set by the authentication handler.
  ///If no name is present it shows null. A note is added with both the cases.
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

  ///This method (pseudo) logs in the user. It reads the body from the POST request
  ///and sets the cookie with name=<user_name> and then redirects to /authenticated
  Future<Response> _login(Request request) async {
    try {
      final body = await handlePostRequest(request);
      var dateFormat = DateFormat('E, d MMM yyyy HH:mm:ss');
      var expirey =
          dateFormat.format(DateTime.now().add(Duration(days: 1)).toUtc()) +
              ' GMT';
      var headers = {
        HttpHeaders.setCookieHeader:
            'name=${body['fname']};path=/;SameSite=Lax;expires=$expirey'
      };
      return Response.found('/authenticated', headers: headers);
    } catch (e) {
      return invalidContentType(
          'Invalid request. Data sent should be of the type "multipart/form-data; boundary=something"');
    }
  }

  Router get router {
    final router = Router();
    router.get('/messages', _messages);
    router.get('/messages/', _messages);
    router.post('/login', _login);
    router.post('/login/', _login);
    //for any other request not matching the path, a notfound response is sent.
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));
    return router;
  }
}
