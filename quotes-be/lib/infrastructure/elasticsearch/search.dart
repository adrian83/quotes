const asc = "asc";
const desc = "desc";

const maxSize = 10000;
const defaultOffset = 0;
const defaultSize = 10;

abstract class Query {
  Map toJson();
}

class MatchAllQuery extends Query {
  Map toJson() => {"match_all": Map<String, String>()};
}

class MatchQuery<T> extends Query {
  String field;
  T value;

  MatchQuery(this.field, this.value);

  Map toJson() => {
        "match": {this.field: this.value}
      };
}

class TermsQuery<T> extends Query {
  String field;
  List<T> values;

  TermsQuery(this.field, this.values);

  Map toJson() => {
        "terms": {this.field: this.values}
      };
}

class BoolQuery extends Query {
  Query must;

  BoolQuery(this.must);

  factory BoolQuery.must(Query must) => BoolQuery(must);

  Map toJson() => {"bool": must.toJson()};
}

class MustQuery extends Query {
  List<Query> queries;

  MustQuery(this.queries);

  Map toJson() => {"must": queries.map((e) => e.toJson()).toList()};
}

class JustQuery extends Query {
  Query query;

  JustQuery(this.query);

  Map toJson() => {"query": query.toJson()};
}

class SortElement {
  String field, dir;

  SortElement(this.field, this.dir);

  factory SortElement.asc(String field) => SortElement(field, asc);

  factory SortElement.desc(String field) => SortElement(field, desc);

  Map toJson() => {
        field: {"order": dir}
      };
}

class SearchRequest {
  int from = 0, size = 10;
  Query query;
  List<SortElement> sort;

  SearchRequest(this.query, this.sort, this.from, this.size);

  factory SearchRequest.all() => SearchRequest(MatchAllQuery(), [], defaultOffset, defaultSize);

  factory SearchRequest.allByQuery(Query query) => SearchRequest(query, [], defaultOffset, maxSize);

  factory SearchRequest.oneByQuery(Query query, List<SortElement> sort) => SearchRequest(query, sort, defaultOffset, 1);

  Map toJson() {
    var map = Map<String, Object>();
    map["size"] = size;
    map["from"] = from;
    map["query"] = query.toJson();
    if (sort != null && sort.length > 0) {
      map["sort"] = sort;
    }
    return map;
  }
}
