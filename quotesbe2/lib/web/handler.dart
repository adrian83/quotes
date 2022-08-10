
import 'package:shelf/shelf.dart';

typedef Handler = Response Function(Request request);

enum HttpMethod { get, post, put, delete }

class Mapping {

  final HttpMethod method;
  final String path;
  final Handler handler;

  Mapping(this.method, this.path, this.handler);
}


Response healthHandler(Request request) => Response.ok('OK');