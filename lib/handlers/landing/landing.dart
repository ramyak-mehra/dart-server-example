import 'package:mustache/mustache.dart';
import 'package:server_example/response_utility.dart';
import 'package:shelf/shelf.dart';
import 'dart:io';

Future<Response> indexLandingHandler(Request request) async {
  return htmlResponse(await renderLandingPage());
}

///It reads the mustache template and renders the landing page
///for the website.
Future<String> renderLandingPage() async {
  final values = {'title': 'This text is  server side rendered'};
  var source =
      await File('/app/lib/handlers/landing/landing.mustache').readAsString();
  final template = Template(source, name: 'template-landing.html');
  var output = template.renderString(values);
  return output;
}
