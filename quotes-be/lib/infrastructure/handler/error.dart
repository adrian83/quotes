import 'dart:io';

import 'package:logging/logging.dart';

import '../web/param.dart';
import '../web/response.dart';
import '../../domain/common/exception.dart';
import '../../infrastructure/elasticsearch/exception.dart';

final Logger logger = Logger('ErrorHandler');

void handleErrors(Object ex, HttpRequest request) {
  logger.severe(StackTrace.current);

  if (ex is SaveFailedException) {
    serverError("cannot save entity", request);
  } else if (ex is UpdateFailedException) {
    serverError("cannot update entity", request);
  } else if (ex is FindFailedException) {
    notFound(request);
  } else if (ex is IndexingFailedException) {
    serverError(ex.toString(), request);
  } else if (ex is InvalidInputException) {
    badRequest(ex.violation, request);
  } else {
    serverError("unknown error ${ex}", request);
  }
}
