import '../common/exception.dart';
import 'form.dart';

class Params {
  ParseElem<String> _authorId, _bookId, _quoteId, _searchPhrase;
  ParseElem<int> _limit, _offset;

  Params([this._authorId, this._bookId, this._quoteId, this._limit, this._offset,
      this._searchPhrase]);

  Params validate() {
    var fields = [_authorId, _bookId, _quoteId, _limit, _offset, _searchPhrase];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return this;
  }

  String get authorId => _authorId.value;
  String get bookId => _bookId.value;
  String get quoteId => _quoteId.value;
  String get searchPhrase => _searchPhrase.value;
  int get limit => _limit.value;
  int get offset => _offset.value;

  void set authorIdParam(ParseElem<String> id) {
    _authorId = id;
  }

  void set bookIdParam(ParseElem<String> id) {
    _bookId = id;
  }

  void set quoteIdParam(ParseElem<String> id) {
    _quoteId = id;
  }

  void set searchPhraseParam(ParseElem<String> phrase) {
    _searchPhrase = phrase;
  }

  void set offsetParam(ParseElem<int> o) {
    _offset = o;
  }

  void set limitParam(ParseElem<int> l) {
    _limit = l;
  }
}
