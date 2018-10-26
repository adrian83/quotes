import 'form.dart';

class SaveFailedException implements Exception {}

class UpdateFailedException implements Exception {}

class FindFailedException implements Exception {}

class InvalidDataException implements Exception {
  List<ParsingError> _errors;

  InvalidDataException(this._errors);

  List<ParsingError> get errors => _errors;
}
