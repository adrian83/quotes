

class Author {
  String _id, _name;

  Author(this._id, this._name);

  String get id => _id;
  String get name => _name;

  factory Author.fromJson(Map<String, dynamic> author) => new Author(author['id'], author['name']);
}
