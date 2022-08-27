import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'package:quotesbe2/web/error.dart';

const headerValueJson = 'application/json';

Response responseBadRequest(List<Violation> violations) => Response(
      400,
      body: jsonEncode(violations),
      headers: {HttpHeaders.contentTypeHeader: headerValueJson},
    );
