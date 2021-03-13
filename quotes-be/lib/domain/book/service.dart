import 'dart:async';

import '../common/model.dart';
import '../quote/repository.dart';
import 'model.dart';
import 'repository.dart';

class BookService {
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  BookService(this._bookRepository, this._bookEventRepository, this._quoteRepository, this._quoteEventRepository);

  Future<Book> save(Book book) => _bookRepository.save(book).then((_) {
        _bookEventRepository.save(BookEvent.create(book));
        return book;
      });

  Future<Book> find(String bookId) => _bookRepository.find(bookId);

  Future<Book> update(Book book) => _bookRepository.update(book).then((book) {
        _bookEventRepository.update(BookEvent.update(book));
        return book;
      });

  Future<void> delete(String bookId) => _bookRepository
      .delete(bookId)
      .then((_) => _bookEventRepository.deleteBook(bookId))
      .then((_) => _quoteRepository.deleteByBook(bookId))
      .then((_) => _quoteEventRepository.deleteByBook(bookId));

  Future<void> deleteByAuthor(String authorId) =>
      _bookRepository.deleteByAuthor(authorId).then((_) => _bookEventRepository.deleteByAuthor(authorId));

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) => _bookRepository.findAuthorBooks(request);

  Future<Page<Book>> findBooks(SearchEntityRequest request) => _bookRepository.findBooks(request);

  Future<Page<BookEvent>> listEvents(ListEventsByBookRequest request) => _bookEventRepository.listEvents(request);
}
