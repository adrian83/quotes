import 'dart:async';

import 'package:logging/logging.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Author> authorDecoder = (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorRepository extends Repository<Author> {
  final Logger logger = Logger('AuthorRepository');

  AuthorRepository(ESStore<Author> store) : super(store, authorDecoder);

  Future<Page<Author>> findAuthors(SearchEntityRequest request) {
    logger.info("find authors $request");
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery("name", phrase);

    return this.findDocuments(query, request.pageRequest);
  }
}

Decoder<AuthorEvent> authorEventDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventRepository extends Repository<AuthorEvent> {
  final Logger logger = Logger('AuthorEventRepository');

  AuthorEventRepository(ESStore<AuthorEvent> store) : super(store, authorEventDecoder);

  Future<Page<AuthorEvent>> findAuthorsEvents(ListEventsByAuthorRequest request) {
    logger.info("find authors events $request");
    var query = MatchQuery("entity.id", request.authorId);
    var sorting = SortElement.asc(createdUtcF);
    return super.findDocuments(query, request.pageRequest, sorting:sorting);
  }

  Future<void> saveAuthor(Author author) {
    return this.save(AuthorEvent.create(author));
  }
 
  Future<void> updateAuthor(Author author) {
    return this.save(AuthorEvent.update(author));
  }

  Future<void> deleteAuthor(String authorId) {
    var idQuery = MatchQuery("entity.id", authorId);
    var sorting = SortElement.desc(modifiedUtcF);

    return super.findDocuments(idQuery, PageRequest(1, 0), sorting:sorting)
    .then((page) => this.save(AuthorEvent.delete(page.elements[0].entity)));
  }

}
