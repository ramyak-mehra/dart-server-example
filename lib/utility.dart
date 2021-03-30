import 'dart:convert';
import 'package:buffer/buffer.dart';
import 'package:shelf/shelf.dart';
import 'package:mime/mime.dart';

Future<Map<String, String>> handlePostRequest(Request request) async {
  final contentHeader = _parse(request.headers['content-type']);
  final formData = <String, String>{};
  final transformer = MimeMultipartTransformer(contentHeader['boundary']);
  await for (final m in request.read().transform(transformer)) {
    final disposition = _parse(m.headers['content-disposition']);
    final name = disposition['name'];
    final data = await readAsBytes(m);

    formData[name] = utf8.decode(data);
  }

  return formData;
}

Map<String, String> _parse(String value) {
  final result = <String, String>{};
  if (value == null || value.isEmpty) {
    return result;
  }
  value.split(';').forEach((p) {
    final parts = p.trim().split('=');
    final key = parts.first;
    var v = parts.last.trim();
    if (v.startsWith('"') && v.endsWith('"')) {
      v = v.substring(1, v.length - 1);
    }
    result[key] = v;
  });
  return result;
}
