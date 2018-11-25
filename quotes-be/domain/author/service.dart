import 'dart:async';

import 'model.dart';
import 'event_repository.dart';
import 'repository.dart';
import '../book/repository.dart';
import '../book/event_repository.dart';
import '../quote/repository.dart';

import '../common/model.dart';

class AuthorService {
  AuthorRepository _authorRepository;
  AuthorEventRepository _authorEventRepository;
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;

  AuthorService(this._authorRepository, this._authorEventRepository,
      this._bookRepository, this._bookEventRepository, this._quoteRepository);

  Future<Page<Author>> findAuthors(PageRequest request) =>
      _authorRepository.findAuthors(request);

  Future<Page<AuthorEvent>> listEvents(String authorId, PageRequest request) =>
      _authorEventRepository.listEvents(authorId, request);

  Future<Author> save(Author author) => _authorRepository
      .save(author.generateId())
      .then((_) => _authorEventRepository.save(author));

  Future<Author> update(Author author) => _authorRepository
      .update(author)
      .then((_) => _authorEventRepository.update(author));

  Future<Author> find(String authorId) => _authorRepository.find(authorId);

  Future<void> delete(String authorId) => _authorRepository
      .delete(authorId)
      .then((_) => _authorEventRepository.delete(authorId))
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _bookEventRepository.deleteByAuthor(authorId));
}
