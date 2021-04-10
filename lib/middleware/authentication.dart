import 'package:shelf/shelf.dart';
import 'dart:io' show HttpHeaders;

///Pseudo authentication handler which acts as a middleware. It checks if there is a cookie header
///If it is present it attaches a context[custom.user] = 'cookie' to the request object.
///This is just to show how can one read the cookies and attach things to the request object
Handler authenticationHandler(innerHandler) => (request) async {
      final headers = request.headers;
      if (headers.containsKey(HttpHeaders.cookieHeader)) {
        final updatedRequest = request.change(
            context: {'custom.user': headers[HttpHeaders.cookieHeader]});
        return await innerHandler(updatedRequest);
      }
      return innerHandler(request);
    };
