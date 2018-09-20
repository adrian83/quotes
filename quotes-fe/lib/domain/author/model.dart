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
  AuthorsPage(int current, int total, int size, List<Author> elements)
      : super(current, total, size, elements);

  factory AuthorsPage.fromJson(Map<String, dynamic> json) {
    var authorsJson = json['authors'];
    List<Author> authors = authorsJson == null
        ? new List<Author>()
        : authorsJson.map((j) => new Author.fromJson(j));

    return new AuthorsPage(json[PAGE], json[TOTAL], json[SIZE], authors);
  }
}
