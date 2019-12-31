import 'dart:io';

import 'router.dart';
import '../../config/config.dart';

class Server {
  ServerConfig config;
  Router router;

  Server(this.config, this.router);

  void start() async {
    HttpServer.bind(config.host, config.port).then((server) => server.listen((request) => router.handleRequest(request)));
  }
}
