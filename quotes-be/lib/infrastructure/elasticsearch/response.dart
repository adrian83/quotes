const noop = "noop";
const created = "created";
const updated = "updated";

class BasicResult {
  String index, type, id;

  BasicResult(this.index, this.type, this.id);

  factory BasicResult.fromJson(Map<String, dynamic> json) => BasicResult(json['_index'], json['_type'], json['_id']);
}

class IndexResult extends BasicResult {
  String result;
  int version;

  IndexResult(String index, String type, String id, this.result, this.version) : super(index, type, id);

  factory IndexResult.fromJson(Map<String, dynamic> json) => IndexResult(json['_index'], json['_type'], json['_id'], json['result'], json['_version']);
}

class UpdateResult extends IndexResult {
  UpdateResult(String index, String type, String id, String result, int version) : super(index, type, id, result, version);

  factory UpdateResult.fromJson(Map<String, dynamic> json) => UpdateResult(json['_index'], json['_type'], json['_id'], json['result'], json['_version']);
}

class DeleteResult extends IndexResult {
  DeleteResult(String index, String type, String id, String result, int version) : super(index, type, id, result, version);

  factory DeleteResult.fromJson(Map<String, dynamic> json) => DeleteResult(json['_index'], json['_type'], json['_id'], json['result'], json['_version']);
}

class GetResult extends BasicResult {
  bool found;
  int version;
  Map<String, dynamic> source;

  GetResult(String index, String type, String id, this.version, this.found, this.source) : super(index, type, id);

  factory GetResult.fromJson(Map<String, dynamic> json) =>
      GetResult(json['_index'], json['_type'], json['_id'], json['_version'], json['found'], json['_source']);
}

class SearchHit extends BasicResult {
  double score;
  Map<String, dynamic> source;

  SearchHit(String index, String type, String id, this.score, this.source) : super(index, type, id);

  factory SearchHit.fromJson(Map<String, dynamic> json) => SearchHit(json['_index'], json['_type'], json['_id'], json['_score'], json['_source']);
}

class SearchHits {
  int total;
  double maxScore;
  List<SearchHit> hits;

  SearchHits(this.total, this.maxScore, this.hits);

  factory SearchHits.fromJson(Map<String, dynamic> json) =>
      SearchHits(json['total'], json['maxScore'], (json['hits'] as List).map((d) => SearchHit.fromJson(d)).toList());
}

class SearchResult {
  bool timedOut;
  int took;
  SearchHits hits;

  SearchResult(this.timedOut, this.took, this.hits);

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(json['timed_out'], json['took'], SearchHits.fromJson(json['hits']));
}

class DeleteByQueryResult {
  bool timedOut;
  int took, deleted;

  DeleteByQueryResult(this.timedOut, this.took, this.deleted);

  factory DeleteByQueryResult.fromJson(Map<String, dynamic> json) => DeleteByQueryResult(json['timed_out'], json['took'], json['deleted']);
}
