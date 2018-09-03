

class Author {
  String id, name;

  Author(this.id, this.name);

  factory Author.fromJson(Map<String, dynamic> author) => new Author(author['id'], author['name']);
}
