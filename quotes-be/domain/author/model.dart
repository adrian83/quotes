import '../common/model.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, [DateTime createdUtc]) : super(id, createdUtc);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json['id'], json['name'], json['description']);

      factory Author.fromDB(List<dynamic> row) =>
      Author(row[0].toString().trim(), row[1].toString().trim(), row[2].toString().trim(), row[3]);

  String get name => _name;
  String get description => _description;

  Map toJson() =>
      super.toJson()..addAll({"name": _name, "description": _description});
}
