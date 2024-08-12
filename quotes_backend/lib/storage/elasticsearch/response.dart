const created = "created";
const updated = "updated";
const noop = "noop";

const timedOutF = "timed_out";
const maxScoreF = "maxScore";
const versionF = "_version";
const deletedF = "deleted";
const sourceF = "_source";
const resultF = "result";
const scoreF = "_score";
const indexF = "_index";
const foundF = "found";
const totalF = "total";
const typeF = "_type";
const hitsF = "hits";
const tookF = "took";
const idF = "_id";

class BasicResult {
  String index, type, id;

  BasicResult(this.index, this.type, this.id);

  factory BasicResult.fromJson(Map<String, dynamic> json) => BasicResult(json[indexF], json[typeF], json[idF]);
}

class IndexResult extends BasicResult {
  String result;
  int version;

  IndexResult(super.index, super.type, super.id, this.result, this.version);

  factory IndexResult.fromJson(Map<String, dynamic> json) => IndexResult(json[indexF], json[typeF], json[idF], json[resultF], json[versionF]);

  @override
  String toString() => "IndexResult [id: $id, type: $type, index: $index, result: $result, version: $version]";
}

class UpdateResult extends IndexResult {
  UpdateResult(super.index, super.type, super.id, super.result, super.version);

  factory UpdateResult.fromJson(Map<String, dynamic> json) => UpdateResult(json[indexF], json[typeF], json[idF], json[resultF], json[versionF]);

  @override
  String toString() => "UpdateResult [id: $id, type: $type, index: $index, result: $result, version: $version]";
}

class DeleteResult extends IndexResult {
  DeleteResult(super.index, super.type, super.id, super.result, super.version);

  factory DeleteResult.fromJson(Map<String, dynamic> json) => DeleteResult(json[indexF], json[typeF], json[idF], json[resultF], json[versionF]);

  @override
  String toString() => "DeleteResult [id: $id, type: $type, index: $index, result: $result, version: $version]";
}

class GetResult extends BasicResult {
  bool found;
  int? version;
  Map<String, dynamic> source;

  GetResult(super.index, super.type, super.id, this.version, this.found, this.source);

  factory GetResult.fromJson(Map<String, dynamic> json) => GetResult(json[indexF], json[typeF], json[idF], json[versionF], json[foundF], json[sourceF] ?? {});

  @override
  String toString() => "GetResult [id: $id, type: $type, index: $index, found: $found ,version: $version, source: $source]";
}

class SearchHit extends BasicResult {
  double score;
  Map<String, dynamic> source;

  SearchHit(super.index, super.type, super.id, this.score, this.source);

  factory SearchHit.fromJson(Map<String, dynamic> json) => SearchHit(json[indexF], json[typeF], json[idF], json[scoreF] ??= 0.0, json[sourceF]);

  @override
  String toString() => "SearchHit [id: $id, type: $type, index: $index, score: $score, source: $source]";
}

class HitsTotal {
  int value;
  String relation;

  HitsTotal(this.value, this.relation);

  factory HitsTotal.fromJson(Map<String, dynamic>? json) {
    if (json == null) return HitsTotal(0, "");
    return HitsTotal(json["value"], json["relation"]);
  }

  @override
  String toString() => "HitsTotal [value: $value, relation: $relation]";
}

List extractList(dynamic json, String name) {
  var l = json[hitsF];
  return l != null ? l as List : [];
}

class SearchHits {
  HitsTotal total;
  double maxScore;
  List<SearchHit> hits;

  SearchHits(this.total, this.maxScore, this.hits);

  factory SearchHits.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SearchHits(HitsTotal(0, ""), 0, List.empty());
    var total = HitsTotal.fromJson(json[totalF]);
    var hits = extractList(json, hitsF).map((d) => SearchHit.fromJson(d)).toList();
    return SearchHits(total, json[maxScoreF] ??= 0.0, hits);
  }

  @override
  String toString() => "SearchHits [total: $total, maxScore: $maxScore, hits: $hits]";
}

class SearchResult {
  bool timedOut;
  int took;
  SearchHits hits;

  SearchResult(this.timedOut, this.took, this.hits);

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    var timedOut = json.containsKey(timedOutF) ? json[timedOutF] : false;
    var took = json.containsKey(tookF) ? json[tookF] : 0;
    var hits = SearchHits.fromJson(json[hitsF]);
    return SearchResult(timedOut, took, hits);
  }

  @override
  String toString() => "SearchResult [timedOut: $timedOut, took: $took, hits: $hits]";
}

class DeleteByQueryResult {
  bool timedOut;
  int took, deleted;

  DeleteByQueryResult(this.timedOut, this.took, this.deleted);

  factory DeleteByQueryResult.fromJson(Map<String, dynamic> json) => DeleteByQueryResult(json[timedOutF], json[tookF], json[deletedF]);

  @override
  String toString() => "DeleteByQueryResult [timedOut: $timedOut, took: $took, deleted: $deleted]";
}
