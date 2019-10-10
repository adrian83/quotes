import 'dart:io';

import 'package:logging/logging.dart';

import 'route.dart';
import 'handler.dart';
import 'param.dart';

class Router {

  static final Logger logger = Logger('AuthorHandler');

  List<Route> _routes = [];
  Handler _notFoundHandler;

  void registerRoute(String path, String method, Handler handler) {
    _routes.add(Route(path, method, handler));
  }

  void set notFoundHandler(Handler handler) {
    _notFoundHandler = handler;
  }

  void handleRequest(HttpRequest request) {
    for (Route route in _routes) {
      if (route.canHandle(request.uri.path, request.method)) {
        route.handle(request);
        return;
      }
    }

    logger.info("Not found. Method: ${request.method}, url: ${request.requestedUri}");
    _notFoundHandler(request, Params.empty());
  }
}
