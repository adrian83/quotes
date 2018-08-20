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

class Quote extends Entity {
  String _text, _language;

  Quote(String id, this._text, this._language) : super(id);

  String get text => _text;
  String get language => _language;

  Map toJson() {
    var map = super.toJson();
    map["text"] = this.text;
    map["language"] = this.language;
    return map;
  }
}

class Author extends Entity {
    String _name;

    Author(String id, this._name) : super(id);

    String get name => _name;

    Map toJson() {
      var map = super.toJson();
      map["name"] = this.name;
      return map;
    }
}
