import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import '../domain/common/exception.dart';
import 'common/exception.dart';
import 'common/form.dart';
import 'response.dart';

abstract class Handler {
  static final Logger logger = Logger('Handler');

  Handler();

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams);
}
