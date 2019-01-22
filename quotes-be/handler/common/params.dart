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

