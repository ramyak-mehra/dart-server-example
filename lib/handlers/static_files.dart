import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart' as mime;
import 'package:shelf_static/shelf_static.dart';

//package:shelf_static provides handy functions to create a static file handler form the filesystem directory
var staticFileHandler = createStaticHandler(
  '/home/f/dart-server-example/lib/static',
);
//Currently not using this. instread using the package https://pub.dev/shelf_static
Future<Response> staticFileHandlerDepricated() async {
  final file = File('/home/f/dart-server-example/lib/static');
  final bytes = file.readAsBytesSync();
  final lastModified = file.lastModifiedSync();
  final contentType = mime.lookupMimeType(file.path) ?? 'octet/binary';
  final header = <String, String>{
    HttpHeaders.contentTypeHeader: contentType,
    HttpHeaders.contentLengthHeader: bytes.length.toString(),
    HttpHeaders.lastModifiedHeader: formatHttpDate(lastModified)
  };
  return Response.ok(bytes, headers: header);
}
