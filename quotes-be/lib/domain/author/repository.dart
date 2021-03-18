import 'dart:async';

import 'package:logging/logging.dart';

import 'model.dart';
import '../common/model.dart';
import '../common/repository.dart';
import '../../common/function.dart';
import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Author> authorDecoder = (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorRepository extends Repository<Author> {
  final Logger _logger = Logger('AuthorRepository');

  AuthorRepository(ESStore<Author> store) : super(store, authorDecoder);

  Future<Page<Author>> findAuthors(SearchEntityRequest request) => Future.value(request)
      .then((_) => _logger.info("find authors by request: $request"))
      .then((_) => WildcardQuery(authorNameLabel, request.searchPhrase ?? ""))
      .then((query) => this.findDocuments(query, request.pageRequest));
}

Decoder<AuthorEvent> authorEventDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventRepository extends Repository<AuthorEvent> {
  final Logger _logger = Logger('AuthorEventRepository');

  String _authorIdProp = "$entityLabel.$idLabel";

  AuthorEventRepository(ESStore<AuthorEvent> store) : super(store, authorEventDecoder);

  Future<Page<AuthorEvent>> findAuthorsEvents(ListEventsByAuthorRequest request) => Future.value(request)
      .then((_) => _logger.info("find author events by request: $request"))
      .then((_) => MatchQuery(_authorIdProp, request.authorId))
      .then((query) => super.findDocuments(query, request.pageRequest, sorting: SortElement.asc(createdUtcLabel)));

  Future<void> storeSaveAuthorEvent(Author author) => Future.value(author)
      .then((_) => _logger.info("save author event (save) for author: $author"))
      .then((_) => this.save(AuthorEvent.create(author)));

  Future<void> storeUpdateAuthorEvent(Author author) => Future.value(author)
      .then((_) => _logger.info("save author event (update) for author: $author"))
      .then((_) => this.save(AuthorEvent.update(author)));

  Future<void> storeDeleteAuthorEvent(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("save author event (delete) for author with id: $authorId"))
      .then((_) => MatchQuery(_authorIdProp, authorId))
      .then((query) => super.findDocuments(query, PageRequest.first(), sorting: SortElement.desc(modifiedUtcLabel)))
      .then((page) => page.elements[0].entity)
      .then((author) => pass(author, (a) => _logger.info("save author event (delete) for author with id: $authorId")))
      .then((author) => this.save(AuthorEvent.delete(author)));
}
