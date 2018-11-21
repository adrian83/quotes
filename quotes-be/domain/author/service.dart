import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';
import 'event_repository.dart';
import 'repository.dart';
import '../book/repository.dart';
import '../quote/repository.dart';

import '../common/model.dart';

class AuthorService {
  AuthorRepository _authorRepository;
  AuthorEventRepository _authorEventRepository;
  BookRepository _bookRepository;
  QuoteRepository _quoteRepository;

  AuthorService(this._authorRepository, this._authorEventRepository,
      this._bookRepository, this._quoteRepository);

  Future<Page<Author>> findAuthors(PageRequest request) =>
      _authorEventRepository.list(request);

  Future<Author> save(Author author) {
    author.id = Uuid().v4();
    return _authorRepository
        .save(author)
        .then((_) => _authorEventRepository.save(author));
  }

  Future<Author> update(Author author) => _authorEventRepository.update(author);
  Future<Author> find(String authorId) =>
    _authorRepository.find(authorId);

  Future<void> delete(String authorId) => _authorEventRepository
      .delete(authorId)
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _quoteRepository.deleteByAuthor(authorId));
}
