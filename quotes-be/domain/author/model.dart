import '../common/model.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, [DateTime createdUtc]) : super(id, createdUtc);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json['id'], json['name'], json['description']);

  String get name => _name;
  String get description => _description;

  Map toJson() =>
      super.toJson()..addAll({"name": _name, "description": _description});
}
