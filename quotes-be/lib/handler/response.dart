import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:quotes/handler/author/params.dart';

import '../domain/common/exception.dart';
import 'common/exception.dart';
import 'common/form.dart';

import 'param.dart';

ContentType jsonHeader = ContentType("application", "json", charset: "utf-8");

void serverError(String msg, HttpRequest request) {
  write(msg, HttpStatus.internalServerError, request);
}

void notFound(HttpRequest request) {
  write(null, HttpStatus.notFound, request);
}

void badRequest(List<ParsingError> errors, HttpRequest request) {
  write(errors, HttpStatus.badRequest, request);
}

void badRequest2(List<Violation> errors, HttpRequest request) {
  write(errors, HttpStatus.badRequest, request);
}

void ok(Object o, HttpRequest request) {
  write(o, HttpStatus.ok, request);
}

void created(Object o, HttpRequest request) {
  write(o, HttpStatus.created, request);
}

void write(Object body, int status, HttpRequest request) {
  var resp = request.response;
  resp.headers.contentType = jsonHeader;

  enableCORS(resp);

  resp.statusCode = status;
  if (body != null) {
    resp.write(jsonEncode(body));
  }
  resp.close();
}

String acceptOriginHeader = "Access-Control-Allow-Origin";
String acceptOrigin = "*";
String acceptHeadersHeader = "Access-Control-Allow-Headers";
String acceptHeaders = "origin, content-type, accept, authorization";
String acceptMethodsHeader = "Access-Control-Allow-Methods";
String acceptMethods = "GET, POST, PUT, DELETE, OPTIONS, HEAD";

void enableCORS(HttpResponse response) {
  response.headers.set(acceptOriginHeader, acceptOrigin);
  response.headers.set(acceptHeadersHeader, acceptHeaders);
  response.headers.set(acceptMethodsHeader, acceptMethods);
}
