import 'dart:io';

import 'router.dart';
import '../../config/config.dart';

class Server {
  ServerConfig config;
  Router router;

  Server(this.config, this.router);

  void start() async {
    var httServer = await HttpServer.bind(config.host, config.port);
    await for (HttpRequest request in httServer) {
      router.handleRequest(request);
    }
  }
}
