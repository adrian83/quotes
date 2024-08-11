import 'package:quotesbe/web/error.dart';
import 'package:shelf/shelf.dart';

import 'package:logging/logging.dart';

import 'package:quotesbe/web/response.dart';
import 'package:quotesbe/storage/elasticsearch/exception.dart';

final Logger _logger = Logger('ExceptionHandler');

Response handleError(Exception ex) {
  _logger.severe("Handling exception: $ex");

  if (ex is IndexingFailedException) {
    return responseInternalError();
  } else if (ex is DocUpdateFailedException) {
    return responseInternalError();
  } else if (ex is DocFindFailedException) {
    return responseNotFound();
  } else if (ex is ValidationException) {
    return responseBadRequest(ex.violations);
  }

  return responseInternalError();
}
