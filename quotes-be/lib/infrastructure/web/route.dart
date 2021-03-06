import 'dart:io';

import 'package:logging/logging.dart';

import 'handler.dart';
import 'param.dart';

class Route {
  static final Logger logger = Logger('Route');

  static final String paramPattern = r"([a-z-A-Z0-9]+)";
  static final String patternEnding = r"[/]?$";
  static final String slash = r"/";

  String _url, _method;
  late RegExp _exp;
  Handler _handler;

  Map<String, int> _pathParamsDesc = Map<String, int>();

  Route(this._url, this._method, this._handler) {
    logger.info("new Route created: method: $_method, url: $_url");

    var urlPatterns = _url.split(slash).map((e) => _isPathParam(e) ? paramPattern : e).join(slash) + patternEnding;

    _exp = RegExp(urlPatterns);

    _pathParamsDesc = _url.split(slash).asMap().map((i, e) => MapEntry(e, i - 1))
      ..removeWhere((e, i) => !_isPathParam(e));

    _pathParamsDesc = _pathParamsDesc.map((e, i) => MapEntry(e.substring(1, e.length - 1), i));
  }

  bool _isPathParam(String elem) => elem.startsWith("{") && elem.endsWith("}");

  bool canHandle(String uri, String method) => method == this._method && _exp.hasMatch(uri);

  void handle(HttpRequest request) {
    logger.info("new request, method: ${request.method}, url: ${request.requestedUri}");
    var segments = request.requestedUri.pathSegments;
    var pathParams = PathParams(segments, _pathParamsDesc);
    var urlParams = UrlParams(request.requestedUri.queryParameters);
    var params = Params(pathParams, urlParams);
    _handler(request, params);
  }
}
