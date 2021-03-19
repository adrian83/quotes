class ValidationError {
  String field, code, message;

  ValidationError([this.field, this.code, this.message]);

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      ValidationError(json['field'], json['code'], json['message']);

  String toString() {
    return "ValidationError { field=$field, code=$code, message=$message }";
  }
}

class ValidationErrors implements Exception {
  List<ValidationError> validationErrors;

  ValidationErrors(List<dynamic> errors) {
    this.validationErrors = errors.map((e) => ValidationError.fromJson(e)).toList();
  }

  factory ValidationErrors.fromJson(List<dynamic> json) => ValidationErrors(json);

  String toString() {
    var s = validationErrors != null ? validationErrors.join(",") : "";
    return "ValidationErrors { validationErrors=[$s] }";
  }
}

class NotFoundError implements Exception {}
