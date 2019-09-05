import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import '../domain/common/exception.dart';
import 'common/exception.dart';
import 'common/form.dart';
import 'response.dart';

Future<F> parseForm<F>(HttpRequest req, FormParser<F> parser) => req
    .transform(utf8.decoder)
    .join()
    .then((content) => jsonDecode(content) as Map)
    .then((data) => parser.parse(data));
