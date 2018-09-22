import 'dart:convert';

class PageInfo {
  int _limit, _offset, _total;

  PageInfo(this._limit, this._offset, this._total);

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      new PageInfo(json['limit'], json['offset'], json['total']);

  int get limit => _limit;
  int get offset => _offset;
  int get total => _total;

  void set offset(int val){
    _offset = val;
  }

  void set limit(int val){
    _limit = val;
  }

  void set total(int val){
    _total = val;
  }

  Map toJson() {
    var map = new Map<String, Object>();
    map["limit"] = this.limit;
    map["offset"] = this.offset;
    map["total"] = this.total;
    return map;
  }

  String toString() => jsonEncode(this);
}

class Page<T> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;
  PageInfo get info => _info;
  bool get empty => this._elements == null || this._elements.length == 0;

  String toString() => jsonEncode(this);
}

class PageRequest {
  int _limit, _offset;

  PageRequest(this._limit, this._offset);

  int get limit => this._limit;
  int get offset => this._offset;

  String toString() => jsonEncode(this);
}
