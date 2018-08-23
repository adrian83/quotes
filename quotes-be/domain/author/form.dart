import '../common/form.dart';

class AuthorForm {
  String _name;

  AuthorForm(this._name);

  String get name => this._name;

  Map<String, Object> toJson() {
    var map = new Map<String, Object>();
    map["name"] = this._name;
    return map;
  }
}

class AuthorFormParser extends FormParser<AuthorForm> {
  ParseResult<AuthorForm> parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object textObj = rawForm["name"];
    if (textObj == null) {
        errors.add(new ParsingError("name", "Name cannot be empty"));
    }

    if(errors.length > 0){
        return new ParseResult.failure(errors);
    }
    return new ParseResult.success(new AuthorForm(textObj.toString()));
  }
}
