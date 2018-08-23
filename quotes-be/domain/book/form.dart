import '../common/form.dart';

class BookForm {
  String _title;

  BookForm(this._title);

  String get title => this._title;

  Map<String, Object> toJson() {
    var map = new Map<String, Object>();
    map["title"] = this._title;
    return map;
  }
}

class BookFormParser extends FormParser<BookForm> {
  ParseResult<BookForm> parse(Map rawForm) {
    List<ParsingError> errors = [];

    Object titleObj = rawForm["title"];
    if (titleObj == null) {
        errors.add(new ParsingError("title", "Title cannot be empty"));
    }

    if(errors.length > 0){
        return new ParseResult.failure(errors);
    }
    return new ParseResult.success(new BookForm(titleObj.toString()));
  }
}
