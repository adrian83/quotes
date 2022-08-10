
import 'dart:async';

import 'package:quotesbe2/web/server.dart';
import 'package:quotesbe2/web/handler.dart';


Future<void> main() async {

  var healthMapping = Mapping(HttpMethod.get, "/health", healthHandler);

  var server = Server(8080, [healthMapping]);
  server.start();
}