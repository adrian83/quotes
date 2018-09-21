import 'dart:convert';

class Entity {
  String _id;

  Entity(this._id);

  String get id => _id;

  void set id(String id) {
    this._id = id;
  }

  Map toJson() {
    var map = new Map<String, Object>();
    map["id"] = this.id;
    return map;
  }

  String toString() => jsonEncode(this);
}

class PageInfo {
  int _limit, _offset, _total;

  PageInfo(this._limit, this._offset, this._total);

  int get limit => _limit;
  int get offset => _offset;
  int get total => _total;

  Map toJson() {
    var map = new Map<String, Object>();
    map["limit"] = this.limit;
    map["offset"] = this.offset;
    map["total"] = this.total;
    return map;
  }

  String toString() => jsonEncode(this);
}

class Page<T extends Entity> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;

  Map toJson() {

    var map = new Map<String, Object>();
    map["info"] = this._info.toJson();
    map["elements"] = this.elements.map((e) => e.toJson()).toList();
    return map;
  }

  String toString() => jsonEncode(this);
}
