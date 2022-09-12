import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/author/model/entity.dart';
import 'package:quotesbe2/domain/author/model/query.dart';
import 'package:quotesbe2/domain/common/repository.dart';
import 'package:quotesbe2/storage/elasticsearch/store.dart';
import 'package:quotesbe2/storage/elasticsearch/search.dart';

Decoder<Author> authorDecoder =
    (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorRepository extends Repository<Author> {
  final Logger _logger = Logger('AuthorRepository');

  AuthorRepository(ESStore<Author> store) : super(store, authorDecoder);

  Future<Page<Author>> findAuthors(
          SearchQuery searchQuery) =>
      Future.value(searchQuery)
          .then((_) => _logger.info("find authors by request: $searchQuery"))
          .then((_) =>
              WildcardQuery(authorNameLabel, searchQuery.searchPhrase ?? ""))
          .then((query) => findDocuments(query, searchQuery.pageRequest,
              sorting: SortElement.desc(modifiedUtcLabel)));
}

Decoder<AuthorEvent> authorEventDecoder =
    (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventRepository extends Repository<AuthorEvent> {
  final Logger _logger = Logger('AuthorEventRepository');

  final String _authorIdProp = "$entityLabel.$idLabel";

  AuthorEventRepository(ESStore<AuthorEvent> store)
      : super(store, authorEventDecoder);

  Future<Page<AuthorEvent>> findAuthorsEvents(
          ListEventsByAuthorQuery request) =>
      Future.value(request)
          .then((_) => _logger.info("find author events by request: $request"))
          .then((_) => MatchQuery(_authorIdProp, request.authorId))
          .then((query) => super.findDocuments(query, request.pageRequest,
              sorting: SortElement.asc(createdUtcLabel)));

  Future<void> storeSaveAuthorEvent(Author author) => Future.value(author)
      .then((_) => _logger.info("save author event (save) for author: $author"))
      .then((_) => save(AuthorEvent.create(author)));

  Future<void> storeUpdateAuthorEvent(Author author) => Future.value(author)
      .then(
          (_) => _logger.info("save author event (update) for author: $author"))
      .then((_) => save(AuthorEvent.update(author)));

  Future<void> storeDeleteAuthorEvent(String authorId) async {
    _logger.info("save author event (delete) for author with id: $authorId");
    var query = MatchQuery(_authorIdProp, authorId);
    var page = await super.findDocuments(query, PageRequest.first(),
        sorting: SortElement.desc(modifiedUtcLabel));
    var author = page.elements[0].entity;
    await save(AuthorEvent.delete(author));
    return;
  }
}
