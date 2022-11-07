const asc = "asc";
const desc = "desc";

const matchAllQ = "match_all";
const wildcardQ = "wildcard";
const rewriteQ = "rewrite";
const matchQ = "match";
const termsQ = "terms";
const valueQ = "value";
const boostQ = "boost";
const queryQ = "query";
const orderQ = "order";
const termQ = "term";
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
  @override
  Map toJson() => {matchAllQ: <String, String>{}};
}

class MatchQuery<T> extends Query {
  String field;
  T value;

  MatchQuery(this.field, this.value);

  @override
  Map toJson() => {
        matchQ: {
          field: {queryQ: value}
        }
      };
}

class WildcardQuery extends Query {
  String field, value;

  WildcardQuery(this.field, this.value);

  @override
  Map toJson() => {
        wildcardQ: {
          field: {valueQ: "*$value*", boostQ: 1.0, rewriteQ: "constant_score"}
        }
      };
}

class TermQuery<T> extends Query {
  String field;
  T value;

  TermQuery(this.field, this.value);

  @override
  Map toJson() => {
        termQ: {field: value}
      };
}

class TermsQuery<T> extends Query {
  String field;
  List<T> values;

  TermsQuery(this.field, this.values);

  @override
  Map toJson() => {
        termsQ: {field: values}
      };
}

class BoolQuery extends Query {
  Query must;

  BoolQuery(this.must);

  factory BoolQuery.must(Query must) => BoolQuery(must);

  @override
  Map toJson() => {boolQ: must.toJson()};
}

class MustQuery extends Query {
  List<Query> queries;

  MustQuery(this.queries);

  @override
  Map toJson() => {mustQ: queries.map((e) => e.toJson()).toList()};
}

class JustQuery extends Query {
  Query query;

  JustQuery(this.query);

  @override
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
  int? from = 0, size = 10;
  Query query;
  List<SortElement> sort;

  SearchRequest(this.query, this.sort, this.from, this.size);

  factory SearchRequest.all() =>
      SearchRequest(MatchAllQuery(), [], defaultOffset, defaultSize);

  factory SearchRequest.allByQuery(Query query) =>
      SearchRequest(query, [], defaultOffset, maxSize);

  factory SearchRequest.oneByQuery(Query query, List<SortElement> sort) =>
      SearchRequest(query, sort, defaultOffset, 1);

  Map toJson() {
    var json = {
      queryQ: query.toJson(),
      sortQ: (sort.isNotEmpty ? sort : defaultSort)
    };

    if (from != null) {
      json[fromQ] = from as Object;
    }

    if (size != null) {
      json[sizeQ] = size as Object;
    }

    return json;
  }
}
