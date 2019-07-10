import 'dart:io';

import 'common.dart';
import 'common/form.dart';

class OptionsHandler extends Handler {
  OptionsHandler() : super();

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams) async {
    ok(null, request);
  }
}
