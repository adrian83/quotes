import 'dart:io';

import 'param.dart';
import 'response.dart';
import 'common/exception.dart';
import '../domain/common/exception.dart';
import '../internal/elasticsearch/exception.dart';


void handleErrors(Object ex, HttpRequest request) {
  if (ex is SaveFailedException) {
    serverError("cannot save entity", request);
  } else if (ex is UpdateFailedException) {
    serverError("cannot update entity", request);
  } else if (ex is FindFailedException) {
    notFound(request);
  } else if (ex is InvalidDataException) {
    badRequest(ex.errors, request);
  } else if (ex is IndexingFailedException) {
    serverError(ex.message, request);
  } else if (ex is InvalidInputException) {
    badRequest2(ex.violation, request);
  } else {
    serverError("unknown error ${ex}", request);
  }
}
