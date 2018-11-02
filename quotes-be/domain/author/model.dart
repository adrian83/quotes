import '../common/model.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description) : super(id);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json['id'], json['name'], json['description']);

  String get name => _name;
  String get description => _description;

  Map toJson() {
    var map = super.toJson();
    map.addAll({"name": _name, "description": _description});
    return map;
  }
}
