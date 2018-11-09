import 'form.dart';

class InvalidDataException implements Exception {
  List<ParsingError> _errors;

  InvalidDataException(this._errors);

  List<ParsingError> get errors => _errors;
}
