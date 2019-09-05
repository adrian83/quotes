import 'dart:io';

import '../config/config.dart';
import '../handler/router.dart';

class Server {
  ServerConfig _config;
  Router _router;

  Server(this._config, this._router);

  ServerConfig get config => _config;
  Router get router => _router;

  void start() async {
    var httServer = await HttpServer.bind(config.host, config.port);
    await for (HttpRequest request in httServer) {
      router.handleRequest(request);
    }
  }
}
