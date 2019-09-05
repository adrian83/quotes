import "package:test/test.dart";
import "package:mockito/mockito.dart";

import "route.dart";

import 'dart:io';

import 'package:logging/logging.dart';

import 'common.dart';
import 'common/form.dart';

void persist(HttpRequest request, PathParams pathParams, UrlParams urlParams) {
  print("works");
}

void main() {
  test("Route can handle only requests with given http method and propper path",
      () {
    // given
    var route = RouteV2("/authors/{authorId}/books/{bookId}", "POST", persist);

    // when
    var result = route.canHandle("/authors/123/books/4534", "POST");

    // then
    expect(result, isTrue);
  });

  test("Route cannot handle requests with http method different than given",
      () {
    // given
    var route = RouteV2("/authors/{authorId}/books/{bookId}", "POST", persist);
    var otherHttpMethods = ["GET", "PUT", "OPTIONS", "HEAD"];

    // when & then
    otherHttpMethods
        .map((method) => route.canHandle("/authors/123/books/4534", method))
        .forEach((result) => expect(result, isFalse));
  });

  test("Route cannot handle requests with path not matching given pattern", () {
    // given
    var route = RouteV2("/authors/{authorId}/books/{bookId}", "POST", persist);
    var differentPaths = [
      "/author/123/books/4534",
      "/authors/123/book/4534",
      "/authors/123/books/4534/something",
      //"/something/authors/123/books/4534"
    ];

    // when & then
    differentPaths
        .map((path) => route.canHandle(path, "POST"))
        .forEach((result) => expect(result, isFalse));
  });
}
