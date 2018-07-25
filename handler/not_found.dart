import 'dart:io';

import './common.dart';

class NotFoundHandler extends Handler {
  NotFoundHandler() : super(r"(\w+)", null);

  void execute(HttpRequest request) async {
    notFound(request);
  }
}
