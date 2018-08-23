import 'package:uuid/uuid.dart';
import 'model.dart';

class BookRepository {
  List<Book> books = new List<Book>();

  Book save(Book book) {
    book.id = new Uuid().v4();
    books.add(book);
    return book;
  }

  List<Book> list() => books;
  Book find(String authorId, String bookId) => books.firstWhere((e) => findByIds(e, authorId, bookId));
  List<Book> findByAuthor(String authorId) => books.where((b) => b.authorId == authorId).toList();

  Book update(Book book) {
    var b = find(book.authorId, book.id);
    if(b == null) {
        return null;
    }
    books.removeWhere((e) => e.id == book.id);
    books.add(book);
    return book;
  }

  void delete(String authorId, String bookId) {
    books.removeWhere((e) => findByIds(e, authorId, bookId));
  }

  bool findByIds(Book book, String authorId, String bookId) {
      return book.authorId == authorId && book.id == bookId;
  }

}
