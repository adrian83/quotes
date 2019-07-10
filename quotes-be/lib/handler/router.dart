import 'dart:io';

import 'package:logging/logging.dart';

import 'common.dart';
import 'common/form.dart';

class Router {
  List<Route> _routes = [];
  Handler _notFoundHandler;

  Router();

  void registerRoute(String path, String method, Handler handler) {
    _routes.add(Route(path, method, handler));
  }

  void set notFoundHandler(Handler handler) {
    _notFoundHandler = handler;
  }

  void handleRequest(HttpRequest request) {
    for (Route parser in _routes) {
      if (parser.canHandle(request.uri.path, request.method)) {
        parser.handle(request);
        return;
      }
    }

    _notFoundHandler.execute(request, PathParams([], {}), UrlParams({}));
  }
}

class Route {
  static final Logger logger = Logger('Route');

  static final String paramPattern = r"([a-z-A-Z0-9]+)";

  String _url, _method;
  RegExp _exp;
  Handler _handler;

  Map<String, int> _pathParamsDesc;

  Route(this._url, this._method, this._handler) {
    logger.info("New handler created. Method: $_method, url: $_url");

    var urlPatterns = _url.split("/").map((e) => _isPathParam(e) ? paramPattern : e).join("/") + r"[/]?$";

    _exp = RegExp(urlPatterns);

    _pathParamsDesc = _url.split("/").asMap().map((i, e) => MapEntry(e, i - 1))
      ..removeWhere((e, i) => !_isPathParam(e));

    _pathParamsDesc = _pathParamsDesc.map((e, i) => MapEntry(e.substring(1, e.length - 1), i));
  }

  bool _isPathParam(String elem) => elem.startsWith("{") && elem.endsWith("}");

  bool canHandle(String uri, String method) {
    if (method != this._method) {
      return false;
    }
    return _exp.hasMatch(uri);
  }

  void handle(HttpRequest request) {
    logger.info("New request. Method: ${request.method}, url: ${request.requestedUri}");
    var segments = request.requestedUri.pathSegments;
    var pathParams = PathParams(segments, _pathParamsDesc);
    var urlParams = UrlParams(request.requestedUri.queryParameters);
    _handler.execute(request, pathParams, urlParams);
  }
}
