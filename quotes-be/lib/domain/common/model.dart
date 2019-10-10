import '../../common/json.dart';

class Entity implements Jsonable {
  String _id;
  DateTime _modifiedUtc, _createdUtc;

  Entity(this._id, this._modifiedUtc, this._createdUtc);

  String get id => _id;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  void set id(String id) {
    this._id = id;
  }

  void set modifiedUtc(DateTime md) {
    _modifiedUtc = md;
  }

  Map toJson() => {"id": _id, "createdUtc": _createdUtc.toIso8601String(), "modifiedUtc": _modifiedUtc.toIso8601String()};
}

class PageRequest {
  int _limit, _offset;

  PageRequest(this._limit, this._offset);

  int get limit => _limit;
  int get offset => _offset;
}

class PageInfo {
  int _limit, _offset, _total;

  PageInfo(this._limit, this._offset, this._total);

  int get limit => _limit;
  int get offset => _offset;
  int get total => _total;

  Map toJson() => {
        "limit": _limit,
        "offset": _offset,
        "total": _total,
      };
}

class Page<T extends Jsonable> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;
  PageInfo get info => _info;

  Map toJson() => {
        "info": _info.toJson(),
        "elements": _elements.map((e) => e.toJson()).toList(),
      };
}
