import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import 'package:quotesbe2/web/error.dart';

const headerValueJson = 'application/json';

const _corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
  "Access-Control-Allow-Headers": "*"
};
const _baseHeaders = {HttpHeaders.contentTypeHeader: headerValueJson};

const _allHeaders = {
  ..._baseHeaders,
  ..._corsHeaders,
};

Response responseBadRequest(List<Violation> violations) => Response(
      400,
      body: jsonEncode(violations),
      headers: _allHeaders,
    );

Response jsonResponseOk(Object body) => Response(
      200,
      body: jsonEncode(body),
      headers: _allHeaders,
    );

Response emptyResponseOk() => Response(
      200,
      headers: _corsHeaders,
    );
