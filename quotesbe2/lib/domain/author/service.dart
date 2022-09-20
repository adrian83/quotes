import 'dart:async';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/author/model/entity.dart';
import 'package:quotesbe2/domain/author/model/command.dart';
import 'package:quotesbe2/domain/author/model/query.dart';
import 'package:quotesbe2/domain/author/repository.dart';
import 'package:quotesbe2/domain/book/repository.dart';
import 'package:quotesbe2/domain/quote/repository.dart';

class AuthorService {
  final AuthorRepository _authorRepository;
  final AuthorEventRepository _authorEventRepository;
  final BookRepository _bookRepository;
  final BookEventRepository _bookEventRepository;
  final QuoteRepository _quoteRepository;
  final QuoteEventRepository _quoteEventRepository;

  AuthorService(
    this._authorRepository,
    this._authorEventRepository,
    this._bookRepository,
    this._bookEventRepository,
    this._quoteRepository,
    this._quoteEventRepository,
  );

  Future<Author> save(NewAuthorCommand command) async {
    var author = command.toAuthor();
    await _authorRepository.save(author);
    await _authorEventRepository.storeSaveAuthorEvent(author);
    return author;
  }

  Future<Author> find(FindAuthorQuery query) =>
      _authorRepository.find(query.authorId);

  Future<Author> update(UpdateAuthorCommand command) async {
    var author = command.toAuthor();
    await _authorRepository.update(author);
    await _authorEventRepository.storeUpdateAuthorEvent(author);
    return author;
  }

  Future<void> delete(DeleteAuthorQuery query) async {
    await _authorRepository.delete(query.authorId);
    await _authorEventRepository.storeDeleteAuthorEvent(query.authorId);
    await _bookRepository.deleteByAuthor(query.authorId);
    await _bookEventRepository.deleteByAuthor(query.authorId);
    await _quoteRepository.deleteByAuthor(query.authorId);
    await _quoteEventRepository.deleteByAuthor(query.authorId);
    return;
  }

  Future<Page<Author>> findAuthors(SearchQuery query) =>
      _authorRepository.findAuthors(query);

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorQuery request) =>
      _authorEventRepository.findAuthorEvents(request);
}
