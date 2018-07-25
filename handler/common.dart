import 'dart:io';
import 'dart:convert';
import '../form/common.dart';

abstract class Handler {
  var JSON_CONTENT = new ContentType("application", "json", charset: "utf-8");

  String _url, _method;

  Handler(this._url, this._method);

  String get url => this._url;

  bool canHandle(String uri, String method) {
    print("URI " + uri + " METHOD " + method);

    if (method != this._method) {
      return false;
    }

    RegExp exp = new RegExp(this._url);
    return exp.hasMatch(uri);
  }

  void execute(HttpRequest request);

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
    resp.statusCode = status;
    if (body != null) {
      resp.write(JSON.encode(body));
    }
    resp.close();
  }
}
