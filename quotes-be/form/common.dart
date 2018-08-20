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

class ParseElem<T> {
  ParsingError _error;
  T _value;

  ParseElem.failure(this._error);
  ParseElem.success(this._value);


  bool hasError() => _error != null;
  T get value => _value;
  ParsingError get error => _error;
}

class PathParseResult {
  Map<String, String> params;

  PathParseResult(this.params);

  ParseElem<int> getInt(String name) {
    ParseElem<String> parsedStr = getString(name);
    if(parsedStr.hasError()) {
        return new ParseElem.failure(parsedStr.error);
    }
    try {
      var value = int.parse(parsedStr.value);
      return new ParseElem.success(value);
    } on FormatException catch (e) {
      var error = new ParsingError(name, "Invalid format");
      return new ParseElem.failure(error);
    }
  }

  ParseElem<String> getString(String name) {
    var obj = params[name];
    if (obj == null) {
      var error = new ParsingError(name, "Cannot be empty");
      return new ParseElem.failure(error);
    }
    return new ParseElem.success(obj.toString());
  }
}

class PathParser {
  List<String> segments;

  PathParser(this.segments);

  PathParseResult parse(Map<String, int> desc) {
    var result = new Map<String, String>();
    var size = segments.length;
    desc.forEach((k, v) {
      if (v < size) {
        result[k] = segments[v];
      }
    });
    return new PathParseResult(result);
  }
}
