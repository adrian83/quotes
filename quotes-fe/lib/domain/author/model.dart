import '../common/page.dart';

import '../../tools/strings.dart';

class Author {
  String _id, _name, _description;

  Author(this._id, this._name, this._description);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json["id"], json["name"], json["description"]);

  factory Author.empty() => Author(null, "", "");

  String get id => _id;
  String get name => _name;
  String get description => _description;
  List<String> get descriptionParts => _description.split("\n");
  String get shortDescription => shorten(_description, 250);

  void set name(String name) {
    this._name = name;
  }

  void set description(String desc) {
    this._description = desc;
  }

  Map toJson() => {"id": _id, "name": _name, "description": _description};
}

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(PageInfo(0, 0, 0), List<Author>());

  factory AuthorsPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var authors = elems.map((j) => Author.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return AuthorsPage(info, authors);
  }
}
