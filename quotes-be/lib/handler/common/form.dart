class ParsingError {
  String _field, _message;

  ParsingError(this._field, this._message);

  String get field => this._field;
  String get message => this._message;

  Map toJson() => {
        "field": _field,
        "message": _message,
      };
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
  F parse(Map rawForm);

  ParsingError check<T>(T obj, Function isValid, ParsingError error) {
    var valid = isValid(obj);
    return valid ? null : error;
  }

  String getString(String name, Map rawForm) {
    var attr = rawForm[name];
    return attr ?? attr.toString().trim();
  }

  // todo introduce Either or Tuple2
  DateTime parseDate(Object dateObj, bool required, List<ParsingError> errors) {
    print("DATE $dateObj");
    String dateStr = (dateObj != null && dateObj.toString().trim().length > 0)
        ? dateObj.toString().trim()
        : null;

    DateTime date = null;
    if (required && dateStr == null) {
      errors.add(ParsingError("createdUtc", "Creation date cannot be empty"));
    } else if (dateStr != null) {
      date = DateTime.parse(dateStr);
    }
    return date;
  }
}

class ParseElem<T> {
  ParsingError _error;
  T _value;

  ParseElem.failure(this._error);
  ParseElem.success(this._value);

  bool hasError() => _error != null;
  T get value => _value;
  ParsingError get error => _error;

  static List<ParsingError> errors(List<ParseElem> elems) {
    List<ParsingError> errors = [];
    for (var e in elems) {
      if (e != null && e.hasError()) {
        errors.add(e.error);
      }
    }
    return errors;
  }
}

class UrlParams {
  Map<String, String> params;

  UrlParams(this.params);

  ParseElem<int> getIntOrElse(String name, int defaultVal) {
    var obj = params[name];
    if (obj == null) {
      return ParseElem.success(defaultVal);
    }
    ParseElem<String> parsedStr = getString(name);
    if (parsedStr.hasError()) {
      return ParseElem.failure(parsedStr.error);
    }
    try {
      var value = int.parse(parsedStr.value);
      return ParseElem.success(value);
      //} on FormatException catch (e) {
    } on FormatException {
      var error = ParsingError(name, "Invalid format");
      return ParseElem.failure(error);
    }
  }

  ParseElem<String> getString(String name) {
    var obj = params[name];
    if (obj == null) {
      var error = ParsingError(name, "Cannot be empty");
      return ParseElem.failure(error);
    }
    return ParseElem.success(obj);
  }

  ParseElem<String> getOptionalString(String name) {
    return ParseElem.success(params[name]);
  }
}

class PathParams {
  Map<String, String> _params;

  PathParams(List<String> segments, Map<String, int> desc) {
    var entries = desc.entries
        .where((e) => e.value < segments.length)
        .map((e) => MapEntry(e.key, segments[e.value]))
        .toList();
    _params = Map<String, String>.fromEntries(entries);
  }

  String getValue(String name) => _params[name];

  ParseElem<String> getString(String name) {
    var obj = _params[name];
    if (obj == null) {
      var error = ParsingError(name, "Cannot be empty");
      return ParseElem.failure(error);
    }
    return ParseElem.success(obj.toString());
  }

  ParseElem<int> getInt(String name) {
    ParseElem<String> parsedStr = getString(name);
    if (parsedStr.hasError()) {
      return ParseElem.failure(parsedStr.error);
    }
    try {
      var value = int.parse(parsedStr.value);
      return ParseElem.success(value);
    } on FormatException catch (e) {
      print(e);
      var error = ParsingError(name, "Invalid format");
      return ParseElem.failure(error);
    }
  }
}
