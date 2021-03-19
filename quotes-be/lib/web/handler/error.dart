import 'dart:io';

import 'package:logging/logging.dart';

import '../../domain/common/exception.dart';
import '../../infrastructure/web/exception.dart';
import '../../infrastructure/web/param.dart';
import '../../infrastructure/web/response.dart';

final Logger logger = Logger('ErrorHandler');

void handleErrors(Object ex, HttpRequest request) {
  logger.severe(StackTrace.current);

  if (ex is SaveFailedException) {
    serverError("cannot save entity", request);
  } else if (ex is UpdateFailedException) {
    serverError("cannot update entity", request);
  } else if (ex is FindFailedException) {
    notFound(request);
  } else if (ex is InvalidInputException) {
    badRequest(ex.violation, request);
  } else if (ex is InvalidPathParameterException) {
    badRequest(ex.violations, request);
  } else {
    serverError("unknown error ${ex}", request);
  }
}
