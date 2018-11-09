import 'dart:io';

import 'common.dart';
import 'common/form.dart';

class NotFoundHandler extends Handler {
  NotFoundHandler() : super(r"/{anything}", null);

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams) async {
    notFound(request);
  }
}
