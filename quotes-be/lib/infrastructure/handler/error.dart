import 'dart:io';

import '../web/param.dart';
import '../web/response.dart';
import '../../domain/common/exception.dart';
import '../../infrastructure/elasticsearch/exception.dart';

void handleErrors(Object ex, HttpRequest request) {
  if (ex is SaveFailedException) {
    serverError("cannot save entity", request);
  } else if (ex is UpdateFailedException) {
    serverError("cannot update entity", request);
  } else if (ex is FindFailedException) {
    notFound(request);
  } else if (ex is IndexingFailedException) {
    serverError(ex.message, request);
  } else if (ex is InvalidInputException) {
    badRequest(ex.violation, request);
  } else {
    serverError("unknown error ${ex}", request);
  }
}
