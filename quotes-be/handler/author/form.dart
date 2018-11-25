import '../common/form.dart';
import '../common/exception.dart';

class AuthorForm {
  String _name, _description;
  DateTime _createdUtc;

  AuthorForm(this._name, this._description, this._createdUtc);

  String get name => _name;
  String get description => _description;
  DateTime get createdUtc => _createdUtc;

  Map<String, Object> toJson() => {
        "name": _name,
        "description": _description,
        "createdUtc": _createdUtc.toIso8601String()
      };
}

class AuthorFormParser extends FormParser<AuthorForm> {
  bool _creationDateRequired;

  AuthorFormParser([bool creationDateRequired]) {
    _creationDateRequired = creationDateRequired;
  }

  AuthorForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object nameObj = rawForm["name"];
    if (nameObj == null || nameObj.toString().trim().length == 0) {
      errors.add(ParsingError("name", "Name cannot be empty"));
    }

    Object descObj = rawForm["description"];
    if (descObj == null || descObj.toString().trim().length == 0) {
      errors.add(ParsingError("description", "Description cannot be empty"));
    }

    Object creationDateObj = rawForm["createdUtc"];
    print("CREATION DATE $creationDateObj");
    String creationDateStr = (creationDateObj != null &&
            creationDateObj.toString().trim().length > 0)
        ? creationDateObj.toString().trim()
        : null;

        print("CREATION DATE $creationDateStr");

    DateTime createdUtc = null;
    if (_creationDateRequired && creationDateStr == null) {
      errors.add(ParsingError("createdUtc", "Creation date cannot be empty"));
    } else if (creationDateStr != null) {
      createdUtc = DateTime.parse(creationDateStr);
    }

    if (errors.length > 0) {
      print("VALIDATION ERRORS");
      throw InvalidDataException(errors);
    }

    return AuthorForm(nameObj.toString(), descObj.toString(), createdUtc);
  }
}
