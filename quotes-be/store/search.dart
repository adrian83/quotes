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

class SearchRequest {
  int _from = 0, _size = 10;
  Query _query;

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

  Map toJson() {
    var map = Map<String, Object>();
    map["size"] = _size;
    map["from"] = _from;
    map["query"] = _query.toJson();
    return map;
  }
}
