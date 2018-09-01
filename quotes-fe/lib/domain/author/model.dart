

class Author {
  String id;

  Author(this.id);

  factory Author.fromJson(Map<String, dynamic> author) => new Author(author['id']);
}
