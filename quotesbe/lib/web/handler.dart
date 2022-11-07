import 'package:quotesbe/web/response.dart';
import 'package:shelf/shelf.dart';

enum HttpMethod { get, post, put, delete, options }

class Mapping {

  static final String paramPattern = r"[a-z-A-Z0-9]+";
  static final String slash = r"/";

  late final String pathPattern;
  final HttpMethod method;
  final String path;
  final Function handler;

  Mapping(this.method, this.path, this.handler) {

    var pathSegments = path.split(slash);

    pathPattern = pathSegments
      .map((segment) => _isPathParam(segment) ? "<${_pathParamName(segment)}|$paramPattern>" : segment)
      .join(slash); 
    
    print("method: $method, path: $path, pathPattern: $pathPattern");
  }

  String _pathParamName(String segment) => segment.substring(1, segment.length-1);

  bool _isPathParam(String elem) => elem.startsWith("{") && elem.endsWith("}");
}


Response healthHandler(Request request) => emptyResponseOk();