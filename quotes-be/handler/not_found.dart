import 'dart:io';

import './common.dart';

class NotFoundHandler extends Handler {
  NotFoundHandler() : super(r"/{anything}", null);

  void execute(HttpRequest request) async {
    notFound(request);
  }
}
