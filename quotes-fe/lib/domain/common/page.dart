import 'dart:convert';

class PageInfo {
  int _limit, _offset, _total;

  PageInfo(this._limit, this._offset, this._total);

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      PageInfo(json['limit'], json['offset'], json['total']);

  int get limit => _limit;
  int get offset => _offset;
  int get total => _total;
  int get curent {
    var current = offset / limit;
    return current.isNaN ? 0 : current.ceil();
  }

  void set offset(int val) {
    _offset = val;
  }

  void set limit(int val) {
    _limit = val;
  }

  void set total(int val) {
    _total = val;
  }

  Map toJson() => {
        "limit": _limit,
        "offset": _offset,
        "total": _total,
      };

  String toString() => jsonEncode(this);
}

class Page<T> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;
  PageInfo get info => _info;
  bool get empty => this._elements == null || this._elements.length == 0;
  T get first => empty ? null : _elements[0];

  void set last(T elem) {
    if(elem == null){
      return;
    }
    if (_elements == null) {
      _elements = [elem];
    } else {
      _elements.add(elem);
    }
  }

  String toString() => jsonEncode(this);
}

const defPageSize = 2;

class PageRequest {
  int _limit, _offset;

  PageRequest(this._limit, this._offset);

  PageRequest.page(int pageNumber)
      : this(defPageSize, defPageSize * pageNumber);

  int get limit => this._limit;
  int get offset => this._offset;

  String toString() => jsonEncode(this);
}
