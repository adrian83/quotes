import '../common/exception.dart';
import 'form.dart';

class PageValidParams {
  int _limit, _offset;

  PageValidParams(this._limit, this._offset);

  int get limit => _limit;
  int get offset => _offset;
}

class PageParams {
  ParseElem<int> _limit, _offset;

  PageParams(this._limit, this._offset);

  PageValidParams validate() {
    var fields = [_limit, _offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return PageValidParams(_limit.value, _offset.value);
  }

  ParseElem<int> get limit => _limit;
  ParseElem<int> get offset => _offset;
}

class SearchValidParams extends PageValidParams {
  String _searchPhrase;

  SearchValidParams(this._searchPhrase, int limit, int offset)
      : super(limit, offset);

  String get searchPhrase => _searchPhrase;
}

class SearchParams extends PageParams {
  ParseElem<String> _searchPhrase;

  SearchParams(this._searchPhrase, ParseElem<int> limit, ParseElem<int> offset) : super(limit, offset);

  SearchValidParams validate() {
    var fields = [_searchPhrase, _limit, _offset];
    var errors = ParseElem.errors(fields);
    if (errors.length > 0) {
      throw InvalidDataException(errors);
    }
    return SearchValidParams(_searchPhrase.value, _limit.value, _offset.value);
  }
}


class Params {
  ParseElem<String> _authorId, _bookId, _quoteId, _searchPhrase;
  ParseElem<int> _limit, _offset;

  Params(
      [this._authorId,
      this._bookId,
      this._quoteId,
      this._limit,
      this._offset,
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
