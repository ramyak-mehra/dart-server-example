import 'package:mustache/mustache.dart';
import 'package:server_example/response_utility.dart';
import 'package:shelf/shelf.dart';
import 'dart:io';

Future<Response> indexLandingHandler(Request request) async {
  Future<String> renderLanding() async {
    return renderLandingPage();
  }

  return htmlResponse(await renderLanding());
}

Future<String> renderLandingPage() async {
  final values = {'title': 'This text is  server side rendered'};

  var source = await File(
          '/home/oopsies/server-example/lib/handlers/landing/landing.mustache')
      .readAsString();
  final template = Template(source, name: 'template-landing.html');
  var output = template.renderString(values);
  return output;
}