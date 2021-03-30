import 'package:shelf/shelf.dart';
import 'dart:io' show HttpHeaders;

Handler authenticationHandler(innerHandler) => (request) async {
      final headers = request.headers;
      if (headers.containsKey(HttpHeaders.cookieHeader)) {
        final updatedRequest = request.change(
            context: {'custom.user': headers[HttpHeaders.cookieHeader]});
        return await innerHandler(updatedRequest);
      }
      return innerHandler(request);
    };
