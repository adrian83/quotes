import 'dart:async';
import 'dart:io';

abstract class Handler {
  String _url, _method;

  Handler(this._url, this._method);

  String get url => this._url;

  bool canHandle(String uri, String method) {
    return method == this._method && uri == this._url;
  }

  void execute(HttpRequest request);

  HttpResponse jsonResponse(HttpRequest request) {
    var response = request.response;
    response.headers.contentType =
        new ContentType("application", "json", charset: "utf-8");
    return response;
  }
}
