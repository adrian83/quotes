import 'dart:async';

import 'repository.dart';
import 'model.dart';
import '../common/model.dart';

class BookService {
  BookRepository _bookRepository;

  BookService(this._bookRepository);

  Future<Page<Book>> findAuthors(PageRequest request) => _bookRepository.list(request);
  Future<Book> save(Book book) => _bookRepository.save(book);
  Future<Book> update(Book book) => _bookRepository.update(book);
  Future<Book> find(String bookId) => _bookRepository.find(bookId);
  Future<void> delete(String bookId) => _bookRepository.delete(bookId);
}
