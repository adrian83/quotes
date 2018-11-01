import 'package:uuid/uuid.dart';

import 'errors.dart';

class Event {
String _type, _id;

Event(this._type) {
  this._id = Uuid().v4();
}

String get id => _id;
String get type => _type;
}

const warningType = "warning";
const infoType = "info";
const errorType = "error";

class InfoEvent extends Event{
  String _info;

  InfoEvent(this._info): super(infoType);

  String get info => _info;
}

class ErrorEvent extends Event{
  String _msg;

  ErrorEvent(this._msg): super(errorType);

  String get msg => _msg;
}

class InvalidDataEvent extends Event{
  List<ValidationError> _errors;

  InvalidDataEvent(this._errors): super(warningType);

  List<ValidationError> get errors => _errors;
}
