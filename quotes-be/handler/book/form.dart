import '../common/form.dart';
import '../common/exception.dart';

class BookForm {
  String _title, _description;

  BookForm(this._title, this._description);

  String get title => _title;
  String get description => _description;

  Map<String, Object> toJson() => {"title": _title, "description": _description};
}

class BookFormParser extends FormParser<BookForm> {
  BookForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    if (titleObj == null || titleObj.toString().trim().isEmpty) {
      errors.add(ParsingError("title", "Title cannot be empty"));
    }

    Object descriptionObj = rawForm["description"];
    if (descriptionObj == null || descriptionObj.toString().trim().isEmpty) {
      errors.add(ParsingError("title", "Description cannot be empty"));
    }

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return BookForm(titleObj.toString(), descriptionObj.toString());
  }
}
