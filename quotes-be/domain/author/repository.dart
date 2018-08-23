import 'package:uuid/uuid.dart';
import 'model.dart';

class AuthorRepository {
  List<Author> authors = new List<Author>();

  Author save(Author author) {
    author.id = new Uuid().v4();
    authors.add(author);
    return author;
  }

  List<Author> list() => authors;
  Author find(String authorId) => authors.firstWhere((e) => e.id == authorId);

  Author update(Author author) {
    authors.removeWhere((e) => e.id == author.id);
    authors.add(author);
    return author;
  }

  void delete(String authorId) {
    authors.removeWhere((e) => e.id == authorId);
  }

}
