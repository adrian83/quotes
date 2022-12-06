const fieldValidationErrorField = "field";
const fieldValidationErrorMessage = "message";

class ValidationError {
  final String field, message;

  ValidationError(this.field, this.message);

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      ValidationError(
          json[fieldValidationErrorField], json[fieldValidationErrorMessage]);

  @override
  String toString() =>
      "ValidationError { $fieldValidationErrorField=$field, $fieldValidationErrorMessage=$message }";
}

class ValidationErrors implements Exception {
  late final List<ValidationError> validationErrors;

  ValidationErrors(List<dynamic> errors) {
    validationErrors = errors.map((e) => ValidationError.fromJson(e)).toList();
  }

  factory ValidationErrors.fromJson(List<dynamic> json) =>
      ValidationErrors(json);

  @override
  String toString() =>
      "ValidationErrors { validationErrors=[${validationErrors.join(",")}] }";
}

class NotFoundError implements Exception {}
