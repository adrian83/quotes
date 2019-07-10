import '../common/exception.dart';
import '../common/form.dart';
import '../book/params.dart';

class QuoteIdValidParams extends BookIdValidParams {
  String _quoteId;

  QuoteIdValidParams(String authorId, String bookId, this._quoteId) : super(authorId, bookId);

  String get quoteId => _quoteId;
}

class QuoteIdParams extends BookIdParams {
  ParseElem<String> _quoteId;

  QuoteIdParams(ParseElem<String> authorId, ParseElem<String> bookId, this._quoteId) : super(authorId, bookId);

  QuoteIdValidParams validate() {
    var fields = [authorId, bookId, _quoteId];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return QuoteIdValidParams(authorId.value, bookId.value, _quoteId.value);
  }
}

class ListByQuoteValidParams extends ListByBookValidParams {
  String _quoteId;

  ListByQuoteValidParams(String authorId, String bookId, this._quoteId, int limit, int offset)
      : super(authorId, bookId, limit, offset);

  String get quoteId => _quoteId;
}

class ListByQuoteParams extends ListByBookParams {
  ParseElem<String> _quoteId;

  ListByQuoteParams(
      ParseElem<String> authorId, ParseElem<String> bookId, this._quoteId, ParseElem<int> limit, ParseElem<int> offset)
      : super(authorId, bookId, limit, offset);

  ListByQuoteValidParams validate() {
    var fields = [authorId, bookId, _quoteId, limit, offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return ListByQuoteValidParams(authorId.value, bookId.value, _quoteId.value, limit.value, offset.value);
  }
}
