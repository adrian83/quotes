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
    var query = TermQuery("name", phrase); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }
}
