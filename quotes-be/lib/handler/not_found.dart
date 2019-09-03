import 'dart:io';

import 'package:logging/logging.dart';

import 'common/form.dart';
import 'common.dart';
import 'response.dart';

class NotFoundHandler extends Handler {
  static final Logger logger = Logger('NotFoundHandler');

  NotFoundHandler() : super(); //r"/{anything}", null);

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) async {
    logger.info("Not found. Method: ${req.method}, url: ${req.requestedUri}");
    notFound(req);
  }
}
