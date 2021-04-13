import 'package:logging/logging.dart';

import 'model.dart';
import 'repository.dart';
import '../common/model.dart';
import '../common/exception.dart';
import '../book/repository.dart';
import '../quote/repository.dart';
import '../../common/function.dart';

class AuthorService {
  final Logger _logger = Logger('AuthorService');

  AuthorRepository _authorRepository;
  AuthorEventRepository _authorEventRepository;
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  AuthorService(this._authorRepository, this._authorEventRepository, this._bookRepository, this._bookEventRepository,
      this._quoteRepository, this._quoteEventRepository);

  Future<Author> save(Author author) => Future.value(author)
      .then((_) => _logger.info("save author: $author"))
      .then((_) => _authorRepository.save(author))
      .then((_) => _logger.info("store author event (create) for author: $author"))
      .then((_) => pass(author, (a) => _authorEventRepository.storeSaveAuthorEvent(author)))
      .catchError(errorHandler);

  Future<Author> find(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("find author by id: $authorId"))
      .then((_) => _authorRepository.find(authorId))
      .catchError(errorHandler);

  Future<Author> update(Author author) => Future.value(author)
      .then((_) => _logger.info("update author: $author"))
      .then((_) => _authorRepository.update(author))
      .then((_) => _logger.info("store author event (update) for author: $author"))
      .then((_) => pass(author, (a) => _authorEventRepository.storeUpdateAuthorEvent(author)))
      .catchError(errorHandler);

  Future<void> delete(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete author with id: $authorId"))
      .then((_) => _authorRepository.delete(authorId))
      .then((_) => _logger.info("store author event (delete) for author with id: $authorId"))
      .then((_) => _authorEventRepository.storeDeleteAuthorEvent(authorId))
      .then((_) => _logger.info("delete all books created by author with id: $authorId"))
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _logger.info("store book events (delete) for all book created by author with id: $authorId"))
      .then((_) => _bookEventRepository.deleteByAuthor(authorId))
      .then((_) => _logger.info("delete all quotes from all books created by author with id: $authorId"))
      .then((_) => _quoteRepository.deleteByAuthor(authorId))
      .then((_) => _logger.info("store quote events (delete) of author with id: $authorId"))
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId))
      .catchError(errorHandler);

  Future<Page<Author>> findAuthors(SearchEntityRequest request) => Future.value(request)
      .then((_) => _logger.info("find authors by request: $request"))
      .then((_) => _authorRepository.findAuthors(request))
      .catchError(errorHandler);

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorRequest request) => Future.value(request)
      .then((_) => _logger.info("find author events by request: $request"))
      .then((_) => _authorEventRepository.findAuthorsEvents(request))
      .catchError(errorHandler);
}
