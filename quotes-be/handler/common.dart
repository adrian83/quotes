import 'dart:io';
import 'dart:convert';
import 'dart:async';

import '../domain/common/form.dart';
import '../domain/common/exception.dart';

abstract class Handler {
  var JSON_CONTENT = ContentType("application", "json", charset: "utf-8");

  String _url, _method;
  RegExp _exp;

  Map<String, int> params =  Map<String, int>();

  Handler(this._url, this._method) {
    var urlPatterns = _transoformURI(this._url);
    print("Url: $_url, RegExp: $urlPatterns");
    _exp =  RegExp(urlPatterns);
  }

  String _transoformURI(String urlPatterns) {
    var elems = urlPatterns.split("/");
    var result = "";
    for (var i = 0; i < elems.length; i++) {
      var e = elems[i];
      if (e.startsWith("{") && e.endsWith("}")) {
        result += r"/([a-z-A-Z0-9]+)";

        var key = e.substring(1, e.length - 1);
        params[key] = i - 1;
      } else if (e != "") {
        result += "/" + e;
      }
    }

    result += r"[/]?$";
    return result;
  }

  PathParseResult parsePath(List<String> segments) {
    var pathParser = PathParser(segments);
    var pathResult = pathParser.parse(params);
    return pathResult;
  }

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

  void handleErrors(Exception ex, HttpRequest request) {
    if (ex is SaveFailedException) {
      serverError("cannot save entity", request);
    } else if (ex is UpdateFailedException) {
      serverError("cannot update entity", request);
    } else if (ex is FindFailedException) {
      notFound(request);
    } else if (ex is InvalidDataException) {
      badRequest(ex.errors, request);
    } else {
      serverError("unknown error", request);
    }
  }

  void handle(HttpRequest request) {
    var pathParams = parsePath(request.requestedUri.pathSegments);
    var uriParams = UrlParams(request.requestedUri.queryParameters);
    execute(request, pathParams, uriParams);
  }

  void execute(
      HttpRequest request, PathParseResult pathParams, UrlParams urlParams);

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
    resp.headers.contentType = JSON_CONTENT;

    // cors
    resp.headers.set("Access-Control-Allow-Origin", "*");
    resp.headers.set("Access-Control-Allow-Headers",
        "origin, content-type, accept, authorization");
    resp.headers.set("Access-Control-Allow-Methods",
        "GET, POST, PUT, DELETE, OPTIONS, HEAD");

    resp.statusCode = status;
    if (body != null) {
      resp.write(jsonEncode(body));
    }
    resp.close();
  }
}
