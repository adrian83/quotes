import 'repository.dart';
import 'model.dart';

class BookService {
  BookRepository _bookRepository;

  BookService(this._bookRepository);

  List<Book> findBooks() => _bookRepository.list();
  Book save(Book book) => _bookRepository.save(book);
  Book update(Book book) => _bookRepository.update(book);
  Book find(String authorId, String bookId) => _bookRepository.find(authorId, bookId);
  List<Book> findByAuthor(String authorId) => _bookRepository.findByAuthor(authorId);

  void delete(String authorId, String bookId) {
    _bookRepository.delete(authorId, bookId);
  }

}
