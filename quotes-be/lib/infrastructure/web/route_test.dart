import 'dart:io';

import "package:test/test.dart";
import 'package:mocktail/mocktail.dart';

import "handler.dart";
import "route.dart";
import 'param.dart';

Handler generateHandler(Map<String, String> pathParamsMap, Map<String, String> urlParamsMap) {
  return (HttpRequest request, Params params) {
    expect(params.size, equals(pathParamsMap.length));
    pathParamsMap.forEach((k, v) => expect(v, equals(params.getValue(k))));
  };
}

class HttpRequestMock extends Mock implements HttpRequest {}

void main() {
  test("Route can handle only requests with given http method and propper path", () {
    // given
    var route = Route("/authors/{authorId}/books/{bookId}", "POST", generateHandler({}, {}));

    // when
    var result = route.canHandle("/authors/123/books/4534", "POST");

    // then
    expect(result, isTrue);
  });

  test("Route cannot handle requests with http method different than given", () {
    // given
    var route = Route("/authors/{authorId}/books/{bookId}", "POST", generateHandler({}, {}));
    var otherHttpMethods = ["GET", "PUT", "OPTIONS", "HEAD"];

    // when & then
    otherHttpMethods
        .map((method) => route.canHandle("/authors/123/books/4534", method))
        .forEach((result) => expect(result, isFalse));
  });

  test("Route cannot handle requests with path not matching given pattern", () {
    // given
    var route = Route("/authors/{authorId}/books/{bookId}", "POST", generateHandler({}, {}));
    var differentPaths = ["/author/123/books/4534", "/authors/123/book/4534", "/authors/123/books/4534/something"];

    // when & then
    differentPaths.map((path) => route.canHandle(path, "POST")).forEach((result) => expect(result, isFalse));
  });
/*
  test("Route should handle proper request", () {
    // given
    var uriPattern = "/authors/{authorId}/books/{bookId}";
    var uriString = "/authors/abc/books/def";

    var pathParams = {"authorId": "abc", "bookId": "def"};
    var queryParams = {"limit": "10", "offset": "25"};

    var uri = Uri.http("", uriString, queryParams);
    var request = HttpRequestMock();

    when(request.requestedUri).thenReturn(uri);

    var route = Route(uriPattern, "POST", generateHandler(pathParams, queryParams));

    // when & then
    route.handle(request);
  });
  */
}
