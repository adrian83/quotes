import 'dart:async';

import 'model.dart';
import 'repository.dart';
import 'event.dart';
import '../quote/repository.dart';
import '../quote/event.dart';
import '../common/model.dart';

class BookService {
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  BookService(this._bookRepository, this._bookEventRepository, this._quoteRepository, this._quoteEventRepository);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) =>
      _bookRepository.findBooks(authorId, request);

  Future<Book> save(Book book) => _bookRepository
      .save(book.generateId())
      .then((_) => _bookEventRepository.save(book));

  Future<Book> update(Book book) => _bookRepository.update(book);

  Future<Book> find(String bookId) => _bookRepository.find(bookId);

  Future<void> delete(String bookId) => _bookRepository
      .delete(bookId)
      .then((_) => _bookEventRepository.delete(bookId))
      .then((_) => _quoteRepository.deleteByBook(bookId))
      .then((_) => _quoteEventRepository.deleteByBook(bookId));

  Future<void> deleteByAuthor(String authorId) => _bookRepository
      .deleteByAuthor(authorId)
      .then((_) => _bookEventRepository.deleteByAuthor(authorId));
}
