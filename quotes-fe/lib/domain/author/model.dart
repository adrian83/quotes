import '../common/page.dart';

class Author {
  String _id, _name;

  Author(this._id, this._name);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json['id'], json['name']);

  factory Author.empty() => Author(null, "");

  String get id => _id;
  String get name => _name;

  void set name(String name) {
    this._name = name;
  }

  Map toJson() => {"id": _id, "name": _name};
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
