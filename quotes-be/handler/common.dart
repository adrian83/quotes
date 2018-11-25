import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'common/exception.dart';
import 'common/form.dart';

import '../domain/common/exception.dart';

abstract class Handler {
  ContentType jsonHeader = ContentType("application", "json", charset: "utf-8");

  String _url, _method;
  RegExp _exp;

  Map<String, int> _pathParamsDesc;
  String _paramPattern = r"([a-z-A-Z0-9]+)";

  Handler(this._url, this._method) {
    var urlPatterns = _url
            .split("/")
            .map((e) => isPathParam(e) ? _paramPattern : e)
            .join("/") +
        r"[/]?$";

    _exp = RegExp(urlPatterns);

    _pathParamsDesc = _url.split("/").asMap().map((i, e) => MapEntry(e, i - 1))
      ..removeWhere((e, i) => !isPathParam(e));

    _pathParamsDesc = _pathParamsDesc
        .map((e, i) => MapEntry(e.substring(1, e.length - 1), i));

    print("Url: $_url, RegExp: $urlPatterns");
  }

  DateTime nowUtc() => DateTime.now().toUtc();

  bool isPathParam(String elem) => elem.startsWith("{") && elem.endsWith("}");

  Future<F> parseForm<F>(HttpRequest req, FormParser<F> parser) => req
      .transform(utf8.decoder)
      .join()
      .then((content) => jsonDecode(content) as Map)
      .then((data) => parser.parse(data));

  bool canHandle(String uri, String method) {
    if (method != this._method) {
      return false;
    }
    print(uri);
    return _exp.hasMatch(uri);
  }

  void handleErrors(Object ex, HttpRequest request) {
    if (ex is SaveFailedException) {
      serverError("cannot save entity", request);
    } else if (ex is UpdateFailedException) {
      serverError("cannot update entity", request);
    } else if (ex is FindFailedException) {
      notFound(request);
    } else if (ex is InvalidDataException) {
      badRequest(ex.errors, request);
    } else {
      serverError("unknown error ${ex.runtimeType}", request);
    }
  }

  void handle(HttpRequest request) {
    var segments = request.requestedUri.pathSegments;
    var pathParams = PathParams(segments, _pathParamsDesc);
    var uriParams = UrlParams(request.requestedUri.queryParameters);
    execute(request, pathParams, uriParams);
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
