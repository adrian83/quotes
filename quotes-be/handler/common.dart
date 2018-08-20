import 'dart:io';
import 'dart:convert';

import '../form/common.dart';

abstract class Handler {
  var JSON_CONTENT = new ContentType("application", "json", charset: "utf-8");

  String _method;
  RegExp _exp;

  Handler(String url, this._method){
      _exp = new RegExp(url);
  }

  ParseResult<F> parseForm<F>(HttpRequest request, FormParser<F> parser) async {
    String content = await request.transform(utf8.decoder).join();
    var data = jsonDecode(content) as Map;
    return parser.parse(data);
  }

  bool canHandle(String uri, String method) {
    if (method != this._method) {
      return false;
    }
    return _exp.hasMatch(uri);
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
      resp.write(jsonEncode(body));
    }
    resp.close();
  }
}
