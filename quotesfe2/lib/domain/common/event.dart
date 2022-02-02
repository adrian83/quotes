import 'package:uuid/uuid.dart';

import 'errors.dart';

class Event {
  final String _type;
  final String _id = const Uuid().v4();

  Event(this._type) {}

  String get id => _id;
  String get type => _type;
}

const warningType = "warning";
const infoType = "info";
const errorType = "error";

class InfoEvent extends Event {
  final String _info;

  InfoEvent(this._info) : super(infoType);

  String get info => _info;
}

class ErrorEvent extends Event {
  final String _msg;

  ErrorEvent(this._msg) : super(errorType);

  String get msg => _msg;
}

class InvalidDataEvent extends Event {
  final List<ValidationError> _errors;

  InvalidDataEvent(this._errors) : super(warningType);

  List<ValidationError> get errors => _errors;
}
