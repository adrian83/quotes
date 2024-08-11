class BaseException implements Exception {
  Exception? cause;
  String msg;

  BaseException(this.msg, {this.cause});

  @override
  String toString() => "BaseException [message: $msg, cause: $cause]";
}

class SaveFailedException extends BaseException {
  SaveFailedException(super.msg, {super.cause});
}

class UpdateFailedException extends BaseException {
  UpdateFailedException(super.msg, {super.cause});
}

class FindFailedException extends BaseException {
  FindFailedException(super.msg, {super.cause});
}

class EventModificationException implements Exception {
  @override
  String toString() => "Event modification forbidden";
}
