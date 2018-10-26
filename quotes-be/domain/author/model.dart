import '../common/model.dart';

class Author extends Entity {
  String _name;

  Author(String id, this._name) : super(id);

  factory Author.fromJson(Map<String, dynamic> json) =>
      new Author(json['id'], json['name']);

  String get name => _name;

  Map toJson() {
    var map = super.toJson();
    map.addAll({"name": _name});
    return map;
  }
}
