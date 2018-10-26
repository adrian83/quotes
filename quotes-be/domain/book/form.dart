import '../common/form.dart';

class BookForm {
  String _title;

  BookForm(this._title);

  String get title => _title;

  Map<String, Object> toJson() => {"title": _title};
}

class BookFormParser extends FormParser<BookForm> {
  ParseResult<BookForm> parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    if (titleObj == null) {
      errors.add(new ParsingError("title", "Title cannot be empty"));
    }

    if (errors.length > 0) {
      return new ParseResult.failure(errors);
    }
    return new ParseResult.success(new BookForm(titleObj.toString()));
  }
}
