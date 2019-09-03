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

  test("Rout can handle only requests with given Http method", () {
    var handler = persist;

    var route = RouteV2("/test", "POST", handler);

    var result = route.canHandle("/test", "POST");


    expect(result, isTrue);
  });

}