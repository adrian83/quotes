abstract class Query {
  Map toJson();
}

class MatchAllQuery extends Query {
  Map toJson() {
    var map = Map<String, Object>();
    map["match_all"] = Map<String, String>();
    return map;
  }
}

class MatchQuery<T> extends Query {
  String _field;
  T _value;

  MatchQuery(this._field, this._value);

  Map toJson() => {
        "match": {this._field: this._value}
      };
}

class TermsQuery<T> extends Query {
  String _field;
  List<T> _values;

  TermsQuery(this._field, this._values);

  Map toJson() => {
        "terms": {this._field: this._values}
      };
}

class JustQuery extends Query {
  Query _query;

  JustQuery(this._query);

  Map toJson() => {"query": _query.toJson()};
}

const asc = "asc";
const desc = "desc";

class SortElement {
  String _field, _dir;

  SortElement.asc(this._field) {
    _dir = asc;
  }

  SortElement.desc(this._field) {
    _dir = desc;
  }

  Map toJson() => {
        _field: {"order": _dir}
      };
}

class SearchRequest {
  int _from = 0, _size = 10;
  Query _query;
  List<SortElement> _sort;

  SearchRequest.all() {
    _query = MatchAllQuery();
  }

  SearchRequest();

  void set from(int f) {
    _from = f;
  }

  void set size(int s) {
    _size = s;
  }

  void set query(Query q) {
    _query = q;
  }

  void set sort(List<SortElement> elems) {
    _sort = elems;
  }

  Map toJson() {
    var map = Map<String, Object>();
    map["size"] = _size;
    map["from"] = _from;
    map["query"] = _query.toJson();
    if(_sort != null && _sort.length > 0) {
      map["sort"] = _sort;
    }
    return map;
  }
}
