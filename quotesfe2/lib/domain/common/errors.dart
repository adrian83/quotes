class ValidationError {
  String field, message;

  ValidationError(this.field, this.message);

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      ValidationError(json['field'], json['message']);

  @override
  String toString() {
    return "ValidationError { field=$field, message=$message }";
  }
}

class ValidationErrors implements Exception {
  List<ValidationError> validationErrors = [];

  ValidationErrors(List<dynamic> errors) {
    validationErrors = errors.map((e) => ValidationError.fromJson(e)).toList();
  }

  factory ValidationErrors.fromJson(List<dynamic> json) =>
      ValidationErrors(json);

  @override
  String toString() {
    return "ValidationErrors { validationErrors=[${validationErrors.join(",")}] }";
  }
}

class NotFoundError implements Exception {}
