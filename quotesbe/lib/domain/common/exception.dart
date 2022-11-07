

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
