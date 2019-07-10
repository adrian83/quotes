import '../common/exception.dart';
import '../common/form.dart';

class AuthorForm {
  String _name, _description;
  DateTime _modifiedUtc, _createdUtc;

  AuthorForm(this._name, this._description, this._modifiedUtc, this._createdUtc);

  String get name => _name;
  String get description => _description;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  Map<String, Object> toJson() => {
        "name": _name,
        "description": _description,
        "modifiedUtc": _modifiedUtc.toIso8601String(),
        "createdUtc": _createdUtc.toIso8601String()
      };
}

class AuthorFormParser extends FormParser<AuthorForm> {
  static final int minNameLen = 1, maxNameLen = 200;
  static final nameLabel = "name";
  static final emptyNameMsg = "Name cannot be empty";
  static final invalidNameMsg = "Name length should be between $minNameLen and $maxNameLen";

  static final emptyNameError = ParsingError(nameLabel, emptyNameMsg);
  static final invalidNameError = ParsingError(nameLabel, invalidNameMsg);

  static final int minDescriptionLen = 1, maxDescriptionLen = 5000;
  static final descriptionLabel = "description";
  static final emptyDescriptionMsg = "Description cannot be empty";
  static final invalidDescriptionMsg = "Description length should be between $minDescriptionLen and $maxDescriptionLen";

  static final emptyDescriptionError = ParsingError(descriptionLabel, emptyDescriptionMsg);
  static final invalidDescriptionError = ParsingError(descriptionLabel, invalidDescriptionMsg);

  bool _modificationDateRequired, _creationDateRequired;

  AuthorFormParser(this._modificationDateRequired, this._creationDateRequired);

  bool empty(String str) => str == null || str.length == 0;
  bool shorter(String str, int limit) => str.length < limit;
  bool longer(String str, int limit) => str.length > limit;
  bool lenNotIn(String str, int min, int max) => shorter(str, min) || longer(str, max);

  ParsingError first(List<Function> funcs) {
    for (var f in funcs) {
      var err = f();
      if (err != null) {
        return err;
      }
    }
    return null;
  }

  AuthorForm parse(Map rawForm) {
    String name = getString(nameLabel, rawForm);
    var nameErr = first([
      () => empty(name) ? emptyNameError : null,
      () => lenNotIn(name, minNameLen, maxNameLen) ? invalidNameError : null
    ]);

    String description = getString(descriptionLabel, rawForm);
    var descErr = first([
      () => empty(description) ? emptyDescriptionError : null,
      () => lenNotIn(description, minDescriptionLen, maxDescriptionLen) ? invalidDescriptionError : null
    ]);

    List<ParsingError> errors = [nameErr, descErr]..removeWhere((err) => err == null);

    Object modificationDateObj = rawForm["modifiedUtc"];
    DateTime modifiedUtc = parseDate(modificationDateObj, _modificationDateRequired, errors);

    Object creationDateObj = rawForm["createdUtc"];
    DateTime createdUtc = parseDate(creationDateObj, _creationDateRequired, errors);

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return AuthorForm(name, description, modifiedUtc, createdUtc);
  }
}
