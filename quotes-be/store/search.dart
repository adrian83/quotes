class SearchQuery {
  bool _all;

  SearchQuery.all() {
    _all = true;
  }

  Map toJson() {
    var map = new Map<String, Object>();
    if (_all) {
      map["match_all"] = new Map<String, String>();
    }
    return map;
  }
}

class SearchRequest {
  int _from = 0, _size = 10;

  SearchQuery _query;

  SearchRequest.all() {
    _query = new SearchQuery.all();
  }

  void set from(int f){
    _from = f;
  }

  void set size(int s){
    _size = s;
  }

  Map toJson() {
    var map = new Map<String, Object>();
    map["size"] = _size;
    map["from"] = _from;
    map["query"] = _query.toJson();
    return map;
  }
}
