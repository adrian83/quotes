import '../common/form.dart';
import '../common/exception.dart';

class BookForm {
  String _title;

  BookForm(this._title);

  String get title => _title;

  Map<String, Object> toJson() => {"title": _title};
}

class BookFormParser extends FormParser<BookForm> {
  BookForm parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    if (titleObj == null) {
      errors.add(ParsingError("title", "Title cannot be empty"));
    }

    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }

    return BookForm(titleObj.toString());
  }
}
