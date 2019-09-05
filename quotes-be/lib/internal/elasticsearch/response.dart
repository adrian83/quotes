const noop = "noop";
const created = "created";
const updated = "updated";

class BasicResult {
  String _index, _type, _id;

  BasicResult(this._index, this._type, this._id);

  factory BasicResult.fromJson(Map<String, dynamic> json) =>
      BasicResult(json['_index'], json['_type'], json['_id']);

  String get index => _index;
  String get type => _type;
  String get id => _id;
}

class IndexResult extends BasicResult {
  String _result;
  int _version;

  IndexResult(String index, String type, String id, this._result, this._version)
      : super(index, type, id);

  factory IndexResult.fromJson(Map<String, dynamic> json) {
    print(json);
    return IndexResult(json['_index'], json['_type'], json['_id'],
        json['result'], json['_version']);
  }

  String get result => _result;
}

class UpdateResult extends IndexResult {
  UpdateResult(String index, String type, String id, String result, int version)
      : super(index, type, id, result, version);

  factory UpdateResult.fromJson(Map<String, dynamic> json) => UpdateResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['result'],
      json['_version']);
}

class DeleteResult extends IndexResult {
  DeleteResult(String index, String type, String id, String result, int version)
      : super(index, type, id, result, version);

  factory DeleteResult.fromJson(Map<String, dynamic> json) => DeleteResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['result'],
      json['_version']);
}

class GetResult extends BasicResult {
  bool _found;
  int _version;
  Map<String, dynamic> _source;

  GetResult(String index, String type, String id, this._version, this._found,
      this._source)
      : super(index, type, id);

  factory GetResult.fromJson(Map<String, dynamic> json) => GetResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['_version'],
      json['found'],
      json['_source']);

  Map<String, dynamic> get source => _source;
  bool get found => _found;
  int get version => _version;
}

class SearchHit extends BasicResult {
  double _score;
  Map<String, dynamic> _source;

  SearchHit(String index, String type, String id, this._score, this._source)
      : super(index, type, id);

  factory SearchHit.fromJson(Map<String, dynamic> json) => SearchHit(
      json['_index'],
      json['_type'],
      json['_id'],
      json['_score'],
      json['_source']);

  Map<String, dynamic> get source => _source;
  double get score => _score;
}

class SearchHits {
  int _total;
  double _maxScore;
  List<SearchHit> _hits;

  SearchHits(this._total, this._maxScore, this._hits);

  factory SearchHits.fromJson(Map<String, dynamic> json) => SearchHits(
      json['total'],
      json['maxScore'],
      (json['hits'] as List).map((d) => SearchHit.fromJson(d)).toList());

  int get total => _total;
  double get maxScore => _maxScore;
  List<SearchHit> get hits => _hits;
}

class SearchResult {
  bool _timedOut;
  int _took;
  SearchHits _hits;

  SearchResult(this._timedOut, this._took, this._hits);

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
      json['timed_out'], json['took'], SearchHits.fromJson(json['hits']));

  bool get timedOut => _timedOut;
  int get took => _took;
  SearchHits get hits => _hits;
}

class DeleteByQueryResult {
  bool _timedOut;
  int _took, _deleted;

  DeleteByQueryResult(this._timedOut, this._took, this._deleted);

  factory DeleteByQueryResult.fromJson(Map<String, dynamic> json) =>
      DeleteByQueryResult(json['timed_out'], json['took'], json['deleted']);

  bool get timedOut => _timedOut;
  int get took => _took;
  int get deleted => _deleted;
}
