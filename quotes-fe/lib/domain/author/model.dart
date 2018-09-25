import '../common/page.dart';

class Author {
  String _id, _name;

  Author(this._id, this._name);

  String get id => _id;
  String get name => _name;

  factory Author.fromJson(Map<String, dynamic> author) =>
      new Author(author['id'], author['name']);
}

class AuthorsPage extends Page<Author> {
  AuthorsPage(PageInfo info, List<Author> elements) : super(info, elements);

  AuthorsPage.empty() : super(new PageInfo(0, 0, 0), new List<Author>());

  factory AuthorsPage.fromJson(Map<String, dynamic> json) {
    var authors =
        (json['elements'] as List).map((j) => new Author.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return new AuthorsPage(info, authors);
  }
}
