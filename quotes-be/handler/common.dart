import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import '../domain/common/exception.dart';
import 'common/exception.dart';
import 'common/form.dart';

abstract class Handler {
  static final Logger logger = Logger('Handler');

  static final ContentType jsonHeader =
      ContentType("application", "json", charset: "utf-8");

  Handler();

  DateTime nowUtc() => DateTime.now().toUtc();

  Future<F> parseForm<F>(HttpRequest req, FormParser<F> parser) => req
      .transform(utf8.decoder)
      .join()
      .then((content) => jsonDecode(content) as Map)
      .then((data) => parser.parse(data));

  void handleErrors(Object ex, HttpRequest request) {
    logger.info("Error occured. Error: $ex");
    if (ex is SaveFailedException) {
      serverError("cannot save entity", request);
    } else if (ex is UpdateFailedException) {
      serverError("cannot update entity", request);
    } else if (ex is FindFailedException) {
      notFound(request);
    } else if (ex is InvalidDataException) {
      badRequest(ex.errors, request);
    } else {
      serverError("unknown error ${ex}", request);
    }
  }

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams);

  void serverError(String msg, HttpRequest request) {
    write(msg, HttpStatus.internalServerError, request);
  }

  void notFound(HttpRequest request) {
    write(null, HttpStatus.notFound, request);
  }

  void badRequest(List<ParsingError> errors, HttpRequest request) {
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
}
