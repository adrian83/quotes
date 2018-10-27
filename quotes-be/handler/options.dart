import 'dart:io';

import 'common.dart';
import '../domain/common/form.dart';

class OptionsHandler extends Handler {
  OptionsHandler() : super(r"/{anything}", "OPTIONS");

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) async {
    ok(null, request);
  }
}
