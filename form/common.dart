import 'dart:convert';

class ParsingError {
  String _field, _message;

  ParsingError(this._field, this._message);

  String get field => this._field;
  String get message => this._message;

 Map toJson() {
    var map = new Map<String, Object>();
    map["field"] = this.field;
    map["message"] = this.message;
    return map;
  }

  String toString() {
    return JSON.encode(this);
  }

}

class ParseResult<F> {
  F _form;
  List<ParsingError> _errors;

  ParseResult.failure(this._errors);
  ParseResult.success(this._form);

  List<ParsingError> get errors => this._errors;
  F get form => this._form;

  bool hasErrors() => this._errors != null && this._errors.length > 0;

}

abstract class FormParser<F> {
  ParseResult<F> parse(Map rawForm);
}

