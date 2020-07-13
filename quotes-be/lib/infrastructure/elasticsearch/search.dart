const asc = "asc";
const desc = "desc";

const matchAllQ = "match_all";
const matchQ = "match";
const termsQ = "terms";
const queryQ = "query";
const orderQ = "order";
const sizeQ = "size";
const fromQ = "from";
const sortQ = "sort";
const mustQ = "must";
const boolQ = "bool";

const defaultSort = "_id";
const defaultOffset = 0;
const defaultSize = 10;
const maxSize = 10000;


abstract class Query {
  Map toJson();
}

class MatchAllQuery extends Query {
  Map toJson() => {matchAllQ: Map<String, String>()};
}

class MatchQuery<T> extends Query {
  String field;
  T value;

  MatchQuery(this.field, this.value);

  Map toJson() => {
        matchQ: {this.field: this.value}
      };
}

class TermsQuery<T> extends Query {
  String field;
  List<T> values;

  TermsQuery(this.field, this.values);

  Map toJson() => {
        termsQ: {this.field: this.values}
      };
}

class BoolQuery extends Query {
  Query must;

  BoolQuery(this.must);

  factory BoolQuery.must(Query must) => BoolQuery(must);

  Map toJson() => {boolQ: must.toJson()};
}

class MustQuery extends Query {
  List<Query> queries;

  MustQuery(this.queries);

  Map toJson() => {mustQ: queries.map((e) => e.toJson()).toList()};
}

class JustQuery extends Query {
  Query query;

  JustQuery(this.query);

  Map toJson() => {queryQ: query.toJson()};
}

class SortElement {
  String field, dir;

  SortElement(this.field, this.dir);

  factory SortElement.asc(String field) => SortElement(field, asc);

  factory SortElement.desc(String field) => SortElement(field, desc);

  Map toJson() => {
        field: {orderQ: dir}
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

  Map toJson() => {sizeQ: size, fromQ: from, queryQ: query.toJson(), sortQ: (sort != null && sort.length > 0) ? sort : defaultSort};
}
