import '../common/page.dart';
import '../common/model.dart';

import '../../tools/strings.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Author.fromJson(Map<String, dynamic> json)
      : this(json["id"], json["name"], json["description"], DateTime.parse(json["modifiedUtc"]), DateTime.parse(json["createdUtc"]));

  Author.empty() : this(null, "", "", nowUtc(), nowUtc());

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

  Map toJson() => super.toJson()..addAll({"name": _name, "description": _description});
}

JsonDecoder<Author> _authorJsonDecoder = (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(PageInfo(0, 0, 0), List<Author>());

  AuthorsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_authorJsonDecoder, json);
}
