import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/author/model/entity.dart';
import 'package:quotesbe/domain/author/model/command.dart';
import 'package:quotesbe/domain/author/model/query.dart';
import 'package:quotesbe/domain/author/repository.dart';
import 'package:quotesbe/domain/book/repository.dart';
import 'package:quotesbe/domain/quote/repository.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/domain/page.dart';

class AuthorService {
  final Logger _logger = Logger('AuthorService');

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
    _logger.info("Received new author command. Author: $author");

    var authorDocument = AuthorDocument.fromModel(author);
    _logger.info("Saving author document: $author");

    await _authorRepository.save(authorDocument);
    await _authorEventRepository.storeSaveAuthorEvent(authorDocument);
    return author;
  }

  Future<Author> find(FindAuthorQuery query) => _authorRepository.find(query.authorId);

  Future<Author> update(UpdateAuthorCommand command) async {
    var author = command.toAuthor();
    var authorDocument = AuthorDocument.fromModel(author);
    await _authorRepository.update(authorDocument);
    await _authorEventRepository.storeUpdateAuthorEvent(authorDocument);
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

  Future<Page<Author>> findAuthors(SearchQuery query) => _authorRepository.findAuthors(query);

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorQuery request) => _authorEventRepository.findAuthorEvents(request);
}
