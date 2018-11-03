import 'dart:convert';

import 'package:intl/intl.dart';

import '../../store/document.dart';

var dateFormat = DateFormat('yyyy-MM-dd');

class Entity extends ESDocument {
  String _id;
  DateTime _createdUtc;

  Entity(this._id) {
    _createdUtc = DateTime.now().toUtc();
  }

  String getId() => id;

  String get id => _id;

  void set id(String id) {
    this._id = id;
  }

  Map toJson() => {"id": _id, "created": dateFormat.format(_createdUtc)};

  String toString() => jsonEncode(this);
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

  String toString() => jsonEncode(this);
}

class Page<T extends Entity> {
  PageInfo _info;
  List<T> _elements;

  Page(this._info, this._elements);

  List<T> get elements => _elements;

  Map toJson() => {
        "info": _info.toJson(),
        "elements": _elements.map((e) => e.toJson()).toList(),
      };

  String toString() => jsonEncode(this);
}
