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

  SearchRequest withSize(int size) {
    _size = size;
    return this;
  }

  SearchRequest withFrom(int from) {
    _from = from;
    return this;
  }

  Map toJson() {
    var map = new Map<String, Object>();
    map["size"] = _size;
    map["from"] = _from;
    map["query"] = _query.toJson();
    return map;
  }
}

/*
{
  "from" : 0, "size" : 10,
    "query" : {
        "match_all" : {}
    },

}*/
