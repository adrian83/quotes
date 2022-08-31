import 'dart:async';

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/book/model.dart';
import 'package:quotesbe2/domain/book/repository.dart';

class NewBookCommand {
  final String authorId, title, description;

  NewBookCommand(this.authorId, this.title, this.description);

  Book toBook() => Book(
        const Uuid().v4(),
        title,
        description,
        authorId,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateBookCommand {
  final String id, authorId, title, description;

  UpdateBookCommand(this.id, this.authorId, this.title, this.description);

  Book toBook() => Book(
        const Uuid().v4(),
        title,
        description,
        authorId,
        DateTime.now(),
        DateTime.now(),
      );
}

class FindBookQuery {
  final String authorId, bookId;

  FindBookQuery(this.authorId, this.bookId);
}

class BookService {
  final Logger _logger = Logger('BookService');

  final BookRepository _bookRepository;
  final BookEventRepository _bookEventRepository;
  //QuoteRepository _quoteRepository;
  //QuoteEventRepository _quoteEventRepository;

  BookService(this._bookRepository,
      this._bookEventRepository); //, this._quoteRepository, this._quoteEventRepository);

  Future<Book> save(NewBookCommand command) async {
    var book = command.toBook();
    _logger.info("save book: $book");
    await _bookRepository.save(book);
    _logger.info("store book event (create) for book: $book");
    await _bookEventRepository.storeSaveBookEvent(book);
    return book;
  }

  Future<Book> find(FindBookQuery query) async {
    _logger.info("find book by: $query");
    return await _bookRepository.find(query.bookId);
  }

  Future<Book> update(UpdateBookCommand command) async {
    var book = command.toBook();
    _logger.info("update book: $book");
    await _bookRepository.update(book);
    _logger.info("store book event (update) for book: $book");
    await _bookEventRepository.storeUpdateBookEvent(book);
    return book;
  }

  Future<void> delete(String bookId) => Future.value(bookId)
      .then((_) => _logger.info("delete book with id: $bookId"))
      .then((_) => _bookRepository.delete(bookId))
      .then((_) =>
          _logger.info("store book event (delete) for book with id: $bookId"))
      .then((_) => _bookEventRepository.storeDeleteBookEventByBookId(bookId));
  //.then((_) => _logger.info("delete all quotes from book with id: $bookId"))
  //.then((_) => _quoteRepository.deleteByBook(bookId))
  //.then((_) => _logger.info("store quote events (delete) for book with id: $bookId"))
  //.then((_) => _quoteEventRepository.deleteByBook(bookId));

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete books by author with id: $authorId"))
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _logger
          .info("store quote events (delete) for author with id: $authorId"))
      .then((_) => _bookEventRepository.deleteByAuthor(authorId));

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find author books by request: $request"))
          .then((value) => _bookRepository.findAuthorBooks(request));

  Future<Page<Book>> findBooks(SearchQuery request) => Future.value(request)
      .then((_) => _logger.info("find books by request: $request"))
      .then((_) => _bookRepository.findBooks(request));

  Future<Page<BookEvent>> listEvents(ListEventsByBookRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find book events by request: $request"))
          .then((_) => _bookEventRepository.findBookEvents(request));
}
