import '../common/exception.dart';
import '../common/form.dart';

class AuthorForm {
  String _name, _description;
  DateTime _modifiedUtc, _createdUtc;

  AuthorForm(
      this._name, this._description, this._modifiedUtc, this._createdUtc);

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
  bool _modificationDateRequired, _creationDateRequired;

  AuthorFormParser(this._modificationDateRequired, this._creationDateRequired);

  AuthorForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object nameObj = rawForm["name"];
    String name = nameObj ?? nameObj.toString().trim();
    if (name == null || name.length == 0) {
      errors.add(ParsingError("name", "Name cannot be empty"));
    }

    Object descObj = rawForm["description"];
    String description = descObj ?? descObj.toString().trim();
    if (description == null || description.length == 0) {
      errors.add(ParsingError("description", "Description cannot be empty"));
    }

    Object modificationDateObj = rawForm["modifiedUtc"];
    DateTime modifiedUtc =
        parseDate(modificationDateObj, _modificationDateRequired, errors);

    Object creationDateObj = rawForm["createdUtc"];
    DateTime createdUtc =
        parseDate(creationDateObj, _creationDateRequired, errors);

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return AuthorForm(name, description, modifiedUtc, createdUtc);
  }
}
