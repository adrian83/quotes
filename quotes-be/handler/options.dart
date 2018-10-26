import 'dart:io';

import './common.dart';

class OptionsHandler extends Handler {
  OptionsHandler() : super(r"/{anything}", "OPTIONS");

  void execute(HttpRequest request) async {
    ok(null, request);
  }
}
