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
