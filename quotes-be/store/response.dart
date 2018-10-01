class BasicResult {
  String _index, _type, _id;

  BasicResult(this._index, this._type, this._id);

  factory BasicResult.fromJson(Map<String, dynamic> json) =>
      new BasicResult(json['_index'], json['_type'], json['_id']);

  String get index => _index;
  String get type => _type;
  String get id => _id;
}

class IndexResult extends BasicResult {
  String _result;
  int _version;

  IndexResult(String index, String type, String id, this._result, this._version)
      : super(index, type, id);

  factory IndexResult.fromJson(Map<String, dynamic> json) => new IndexResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['result'],
      json['_version']);

  String get result => _result;
}

class UpdateResult extends IndexResult {
  UpdateResult(String index, String type, String id, String result, int version)
      : super(index, type, id, result, version);

  factory UpdateResult.fromJson(Map<String, dynamic> json) => new UpdateResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['result'],
      json['_version']);
}

class DeleteResult extends IndexResult {
  DeleteResult(String index, String type, String id, String result, int version)
      : super(index, type, id, result, version);

  factory DeleteResult.fromJson(Map<String, dynamic> json) => new DeleteResult(
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

  factory GetResult.fromJson(Map<String, dynamic> json) => new GetResult(
      json['_index'],
      json['_type'],
      json['_id'],
      json['_version'],
      json['found'],
      json['source']);

  Map<String, dynamic> get source => _source;
  bool get found => _found;
  int get version => _version;
}

class SearchHit extends BasicResult {
  double _score;
  Map<String, dynamic> _source;

  SearchHit(String index, String type, String id, this._score, this._source)
      : super(index, type, id);

  factory SearchHit.fromJson(Map<String, dynamic> json) => new SearchHit(
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

  factory SearchHits.fromJson(Map<String, dynamic> json) => new SearchHits(
      json['total'],
      json['maxScore'],
      (json['hits'] as List).map((d) => new SearchHit.fromJson(d)).toList());

  int get total => _total;
  double get maxScore => _maxScore;
  List<SearchHit> get hits => _hits;
}

class SearchResult {
  bool _timedOut;
  int _took;
  SearchHits _hits;

  SearchResult(this._timedOut, this._took, this._hits);

  factory SearchResult.fromJson(Map<String, dynamic> json) => new SearchResult(
      json['timed_out'], json['took'], new SearchHits.fromJson(json['hits']));

  bool get timedOut => _timedOut;
  int get took => _took;
  SearchHits get hits => _hits;
}
