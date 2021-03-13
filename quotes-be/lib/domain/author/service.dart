import 'dart:async';

import 'package:logging/logging.dart';

import '../book/repository.dart';
import '../common/model.dart';
import '../quote/repository.dart';
import 'model.dart';
import 'repository.dart';

class AuthorService {
  AuthorRepository _authorRepository;
  AuthorEventRepository _authorEventRepository;
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  final Logger logger = Logger('AuthorService');

  AuthorService(this._authorRepository, this._authorEventRepository, this._bookRepository, this._bookEventRepository,
      this._quoteRepository, this._quoteEventRepository);

  Future<Author> save(Author author) => _authorRepository.save(author).then((_) {
        _authorEventRepository.saveAuthor(author);
        return author;
      });

  Future<Author> find(String authorId) => _authorRepository.find(authorId);

  Future<Author> update(Author author) => _authorRepository.update(author).then((_) {
        logger.info("update author event: $author");
        _authorEventRepository.updateAuthor(author);
        return author;
      });

  Future<void> delete(String authorId) => _authorRepository
      .delete(authorId)
      .then((_) => _authorEventRepository.deleteAuthor(authorId))
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _bookEventRepository.deleteByAuthor(authorId))
      .then((_) => _quoteRepository.deleteByAuthor(authorId))
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId));

  Future<Page<Author>> findAuthors(SearchEntityRequest request) => _authorRepository.findAuthors(request);

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorRequest request) =>
      _authorEventRepository.findAuthorsEvents(request);

  Future<String> mapping() => _authorRepository.mapping();
}
