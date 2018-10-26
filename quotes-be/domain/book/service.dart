import 'dart:async';

import 'model.dart';
import 'repository.dart';

import '../common/model.dart';

class BookService {
  BookRepository _bookRepository;

  BookService(this._bookRepository);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) =>
      _bookRepository.findBooks(authorId, request);
  Future<Book> save(Book book) => _bookRepository.save(book);
  Future<Book> update(Book book) => _bookRepository.update(book);
  Future<Book> find(String bookId) => _bookRepository.find(bookId);
  Future<void> delete(String bookId) => _bookRepository.delete(bookId);
}
