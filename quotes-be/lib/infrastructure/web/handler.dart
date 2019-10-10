import 'dart:io';

import 'response.dart';
import 'param.dart';

typedef Handler = void Function(HttpRequest request, Params params);

void options(HttpRequest req, Params params) => Future.sync(() => ok(null, req));

void resourceNotFound(HttpRequest req, Params params) => Future.sync(() => notFound(req));

