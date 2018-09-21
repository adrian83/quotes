import 'package:uuid/uuid.dart';
import 'model.dart';
import '../common/model.dart';

class AuthorRepository {
  List<Author> authors = new List<Author>();

  Author save(Author author) {
    author.id = new Uuid().v4();
    authors.add(author);
    return author;
  }

  Page<Author> list() {
    var l = authors.length;
    var info = new PageInfo(l, 0, l);
    return new Page<Author>(info, authors);
  }
  
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
