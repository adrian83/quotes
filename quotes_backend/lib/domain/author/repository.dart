import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_backend/domain/author/model/entity.dart';
import 'package:quotes_backend/domain/author/model/query.dart';
import 'package:quotes_backend/domain/common/repository.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/store.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/search.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/domain/page.dart';

Decoder<AuthorDocument> authorDecoder = (Map<String, dynamic> json) => AuthorDocument.fromJson(json);

class AuthorRepository extends Repository<AuthorDocument> {
  final Logger _logger = Logger('AuthorRepository');

  AuthorRepository(ESStore<AuthorDocument> store) : super(store, authorDecoder);

  Future<Page<AuthorDocument>> findAuthors(SearchQuery searchQuery) async {
    _logger.info("find authors by query: ${searchQuery.toString()}");
    var query = WildcardQuery(fieldAuthorName, searchQuery.searchPhrase ?? "");
    return await findDocuments(query, searchQuery.pageRequest, sorting: sortingByModifiedTimeDesc);
  }
}

Decoder<AuthorEvent> authorEventDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventRepository extends Repository<AuthorEvent> {
  final Logger _logger = Logger('AuthorEventRepository');

  final String _authorIdProp = "$entityLabel.$fieldEntityId";

  AuthorEventRepository(ESStore<AuthorEvent> store) : super(store, authorEventDecoder);

  Future<Page<AuthorEvent>> findAuthorEvents(ListEventsByAuthorQuery request) async {
    _logger.info("find author events by request: $request");
    var query = MatchQuery(_authorIdProp, request.authorId);
    return await super.findDocuments(query, request.pageRequest, sorting: sortingByCreatedTimeAsc);
  }

  Future<void> storeSaveAuthorEvent(AuthorDocument author) async {
    _logger.info("save author event (save) for author: $author");
    await save(AuthorEvent.create(author));
    return;
  }

  Future<void> storeUpdateAuthorEvent(AuthorDocument author) async {
    _logger.info("save author event (update) for author: $author");
    await save(AuthorEvent.update(author));
    return;
  }

  Future<void> storeDeleteAuthorEvent(String authorId) async {
    _logger.info("save author event (delete) for author with id: $authorId");
    var query = MatchQuery(_authorIdProp, authorId);
    var page = await super.findDocuments(query, PageRequest.first(), sorting: sortingByModifiedTimeDesc);
    var author = page.elements.first.entity;
    var authordeleteEvent = AuthorEvent.delete(author);
    await save(authordeleteEvent);
    return;
  }
}
