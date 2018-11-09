import '../common/form.dart';
import '../common/exception.dart';

class AuthorForm {
  String _name, _description; 

  AuthorForm(this._name, this._description);

  String get name => _name;
  String get description => _description;

  Map<String, Object> toJson() => {"name": _name, "description": _description};
}

class AuthorFormParser extends FormParser<AuthorForm> {
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

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return AuthorForm(nameObj.toString(), descObj.toString());
  }
}
