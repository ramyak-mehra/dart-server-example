import 'dart:convert';
import 'package:shelf/shelf.dart';

const _jsonResponseHeaders = <String, String>{
  'content-type': 'application/json; charset="utf-8"',
  'x-content-type-options': 'nosniff',
};

///It generates a html response with content type as 'text/html; charset="utf-8"'
Response htmlResponse(
  String content, {
  int status = 200,
  Map<String, String> headers,
}) {
  headers ??= <String, String>{};
  headers['content-type'] = 'text/html ; charset="utf-8"';
  return Response(status, body: content, headers: headers);
}

///It generates a json response with content type as 'application/json; charset="utf-8"'
Response jsonResponse(
  Map map, {
  int status = 200,
  Map<String, String> headers,
}) {
  final body = JsonUtf8Encoder().convert(map);
  return Response(
    status,
    body: body,
    headers: {
      ..._jsonResponseHeaders,
      if (headers != null) ...headers,
    },
  );
}

///It generates invalid content type response. It's throughs a 415 error.
Response invalidContentType(
  String body, {
  int status = 415,
  Map<String, String> headers,
}) {
  headers ??= <String, String>{};
  if (headers['content-type'] == null) {
    headers['content-type'] = 'text/plain';
  }
  return Response(
    status,
    body: body,
    headers: {
      ...headers,
    },
  );
}
