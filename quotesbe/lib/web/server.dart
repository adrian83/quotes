import 'dart:io';

import 'package:quotesbe/web/handler.dart';
import 'package:quotesbe/web/response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
//import 'package:shelf_static/shelf_static.dart' as shelf_static;

class Server {
  final int _port;
  final List<Mapping> _mappings;
  final bool _enableCors;

  Server(this._port, this._mappings, this._enableCors);

  Future<void> start() async {
    final router = shelf_router.Router();

    for (var mapping in _mappings) {
      _addMapping(router, mapping);
      if(_enableCors) {
        var optionsMapping = Mapping(HttpMethod.options, mapping.path, (Request request) => emptyResponseOk());
        _addMapping(router, optionsMapping);
      }
    }

    final cascade = Cascade().add(router);

    final server = await shelf_io.serve(
      logRequests().addHandler(cascade.handler),
      InternetAddress.anyIPv4,
      _port,
    );

    print('Serving at http://${server.address.host}:${server.port}');
  }

  void _addMapping(shelf_router.Router router, Mapping mapping) {
    switch (mapping.method) {
      case HttpMethod.get:
        router.get(mapping.pathPattern, mapping.handler);
        break;
      case HttpMethod.post:
        router.post(mapping.pathPattern, mapping.handler);
        break;
      case HttpMethod.put:
        router.put(mapping.pathPattern, mapping.handler);
        break;
      case HttpMethod.delete:
        router.delete(mapping.pathPattern, mapping.handler);
        break;
      case HttpMethod.options:
        router.options(mapping.pathPattern, mapping.handler);
        break;
      default:
        throw ArgumentError(
          "invalid mapping, unknown http method ${mapping.method}",
        );
    }
  }
}
