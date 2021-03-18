import 'dart:async';

import '../../infrastructure/elasticsearch/exception.dart';

class BaseException implements Exception {
  Exception? cause;
  String msg;

  BaseException(this.msg, {this.cause});

  @override
  String toString() => "BaseException [message: $msg, cause: $cause]";
}

class SaveFailedException extends BaseException {
  SaveFailedException(String msg, {Exception? cause}) : super(msg, cause: cause);
}

class UpdateFailedException extends BaseException {
  UpdateFailedException(String msg, {Exception? cause}) : super(msg, cause: cause);
}

class FindFailedException extends BaseException {
  FindFailedException(String msg, {Exception? cause}) : super(msg, cause: cause);
}

dynamic errorHandler(Object error) {
  if (error is IndexingFailedException) {
    Future.error(SaveFailedException("cannot store", cause: error));
  } else if (error is IndexingFailedException) {
    Future.error(UpdateFailedException("cannot update", cause: error));
  } else if (error is DocFindFailedException) {
    Future.error(FindFailedException("cannot find", cause: error));
  } else if (error is Exception) {
    Future.error(BaseException("error", cause: error));
  }

  return error;
}
