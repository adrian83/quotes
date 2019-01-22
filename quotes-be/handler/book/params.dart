import '../common/exception.dart';
import '../common/form.dart';
import '../author/params.dart';

class BookIdValidParams extends AuthorIdValidParams {
  String _bookId;

  BookIdValidParams(String authorId, this._bookId) : super(authorId);

  String get bookId => _bookId;
}

class BookIdParams extends AuthorIdParams {
  ParseElem<String> _bookId;

  BookIdParams(ParseElem<String> authorId, this._bookId) : super(authorId);

  BookIdValidParams validate() {
    var fields = [authorId, _bookId];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return BookIdValidParams(authorId.value, _bookId.value);
  }

  ParseElem<String> get bookId => _bookId;
}

class ListByBookValidParams extends ListByAuthorValidParams {
  String _bookId;

  ListByBookValidParams(String authorId, this._bookId, int limit, int offset)
      : super(authorId, limit, offset);

  String get bookId => _bookId;
}

class ListByBookParams extends ListByAuthorParams {
  ParseElem<String> _bookId;

  ListByBookParams(ParseElem<String> authorId, this._bookId,
      ParseElem<int> limit, ParseElem<int> offset)
      : super(authorId, limit, offset);

  ListByBookValidParams validate() {
    var fields = [authorId, _bookId, limit, offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return ListByBookValidParams(
        authorId.value, _bookId.value, limit.value, offset.value);
  }

  ParseElem<String> get bookId => _bookId;
}
