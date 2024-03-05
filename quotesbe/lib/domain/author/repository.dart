import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/author/model/entity.dart';
import 'package:quotesbe/domain/author/model/query.dart';
import 'package:quotesbe/domain/common/repository.dart';
import 'package:quotesbe/storage/elasticsearch/store.dart';
import 'package:quotesbe/storage/elasticsearch/search.dart';

Decoder<Author> authorDecoder =
    (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorRepository extends Repository<Author> {
  final Logger _logger = Logger('AuthorRepository');

  AuthorRepository(ESStore<Author> store) : super(store, authorDecoder);

  Future<Page<Author>> findAuthors(SearchQuery searchQuery) async {
    _logger.info("find authors by query: $searchQuery");
    var query = WildcardQuery(authorNameLabel, searchQuery.searchPhrase ?? "");
    return await findDocuments(
      query,
      searchQuery.pageRequest,
      sorting: sortingByModifiedTimeDesc,
    );
  }
}

Decoder<AuthorEvent> authorEventDecoder =
    (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventRepository extends Repository<AuthorEvent> {
  final Logger _logger = Logger('AuthorEventRepository');

  final String _authorIdProp = "$entityLabel.$idLabel";

  AuthorEventRepository(ESStore<AuthorEvent> store)
      : super(store, authorEventDecoder);

  Future<Page<AuthorEvent>> findAuthorEvents(
    ListEventsByAuthorQuery request,
  ) async {
    _logger.info("find author events by request: $request");
    var query = MatchQuery(_authorIdProp, request.authorId);
    return await super.findDocuments(
      query,
      request.pageRequest,
      sorting: sortingByCreatedTimeAsc,
    );
  }

  Future<void> storeSaveAuthorEvent(Author author) async {
    _logger.info("save author event (save) for author: $author");
    await save(AuthorEvent.create(author));
    return;
  }

  Future<void> storeUpdateAuthorEvent(Author author) async {
    _logger.info("save author event (update) for author: $author");
    await save(AuthorEvent.update(author));
    return;
  }

  Future<void> storeDeleteAuthorEvent(String authorId) async {
    _logger.info("save author event (delete) for author with id: $authorId");
    var query = MatchQuery(_authorIdProp, authorId);
    var page = await super.findDocuments(
      query,
      PageRequest.first(),
      sorting: sortingByModifiedTimeDesc,
    );
    var author = page.elements.first.entity;
    var event = AuthorEvent.delete(author);
    await save(event);
    return;
  }
}
