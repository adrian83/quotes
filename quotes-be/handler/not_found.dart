import 'dart:io';

import 'common.dart';
import '../domain/common/form.dart';

class NotFoundHandler extends Handler {
  NotFoundHandler() : super(r"/{anything}", null);

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) async {
    notFound(request);
  }
}
