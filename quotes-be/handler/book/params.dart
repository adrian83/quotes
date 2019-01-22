import '../common/exception.dart';
import '../common/form.dart';
import '../author/params.dart';
class BookIdValidParams {
  String _authorId, _bookId;

  BookIdValidParams(this._authorId, this._bookId);

  String get authorId => _authorId;
  String get bookId => _bookId;
}

class BookIdParams {
  ParseElem<String> _authorId, _bookId;

  BookIdParams(this._authorId, this._bookId);

  BookIdValidParams validate() {
    var fields = [_authorId, _bookId];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return BookIdValidParams(_authorId.value, _bookId.value);
  }
}

class ListByBookValidParams extends ListByAuthorValidParams {
  String _bookId;

  ListByBookValidParams(String authorId, this._bookId, int limit, int offset)
      : super(authorId, limit, offset);

  String get bookId => _bookId;
}

class ListByBookParams extends ListByAuthorParams {
  ParseElem<String> _bookId;

  ListByBookParams(ParseElem<String> authorId, this._bookId, ParseElem<int> limit, ParseElem<int> offset) : super(authorId, limit, offset);

  ListByBookValidParams validate() {
    var fields = [authorId, _bookId, limit, offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return ListByBookValidParams(authorId.value, _bookId.value, limit.value, offset.value);
  }
}
