import 'dart:async';

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

//import '../book/repository.dart';
//import '../quote/repository.dart';

import 'package:quotesbe2/common/function.dart';
import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/author/model.dart';
import 'package:quotesbe2/domain/author/repository.dart';

class NewAuthorCommand {
  final String name, description;

  NewAuthorCommand(this.name, this.description);

  Author toAuthor() => Author(
      const Uuid().v4(), name, description, DateTime.now(), DateTime.now(),);
}

class UpdateAuthorCommand {
  final String id, name, description;

  UpdateAuthorCommand(this.id, this.name, this.description);

  Author toAuthor() => Author(id, name, description, DateTime.now(), DateTime.now());
}

class FindAuthorQuery {
  final String id;

  FindAuthorQuery(this.id);
}

class DeleteAuthorQuery {
  final String id;

  DeleteAuthorQuery(this.id);
}

class ListAuthorsQuery {
  late PageRequest pageRequest;

  ListAuthorsQuery(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsRequest [pageRequest: $pageRequest]";
}

class AuthorService {
  final Logger _logger = Logger('AuthorService');

  final AuthorRepository _authorRepository;
  final AuthorEventRepository _authorEventRepository;
  //BookRepository _bookRepository;
  //BookEventRepository _bookEventRepository;
  //QuoteRepository _quoteRepository;
  //QuoteEventRepository _quoteEventRepository;

  AuthorService(this._authorRepository,
      this._authorEventRepository); //, this._bookRepository, this._bookEventRepository, this._quoteRepository, this._quoteEventRepository);




  Future<Author> save(NewAuthorCommand command) async {
    var author = command.toAuthor();
    _logger.info("save author: $author");
    await _authorRepository.save(author);
    _logger.info("store author event (create) for author: $author");
    await _authorEventRepository.storeSaveAuthorEvent(author);
    return author;
  }

  Future<Author> find(FindAuthorQuery query) async { 
    _logger.info("find author by id: ${query.id}");
    return _authorRepository.find(query.id);
  }

  Future<Author> update(UpdateAuthorCommand command){
    var author = command.toAuthor();
    return Future.value(author)
      .then((_) => _logger.info("update author: $author"))
      .then((_) => _authorRepository.update(author))
      .then((_) => _logger.info("store author event (update) for author: $author"))
      .then((_) => pass(author,
          (a) => _authorEventRepository.storeUpdateAuthorEvent(author)));
  }

  Future<void> delete(DeleteAuthorQuery query) =>_authorRepository.delete(query.id)
      .then((value) => _authorEventRepository.storeDeleteAuthorEvent(query.id));
  //.then((_) => _logger.info("delete all books created by author with id: $authorId"))
  //.then((_) => _bookRepository.deleteByAuthor(authorId))
  //.then((_) => _logger.info("store book events (delete) for all book created by author with id: $authorId"))
  //.then((_) => _bookEventRepository.deleteByAuthor(authorId))
  //.then((_) => _logger.info("delete all quotes from all books created by author with id: $authorId"))
  //.then((_) => _quoteRepository.deleteByAuthor(authorId))
  //.then((_) => _logger.info("store quote events (delete) of author with id: $authorId"))
  //.then((_) => _quoteEventRepository.deleteByAuthor(authorId));
  

  Future<Page<Author>> findAuthors(SearchQuery query) =>
      Future.value(query)
          .then((_) => _logger.info("find authors by request: $query"))
          .then((_) => _authorRepository.findAuthors(query));

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find author events by request: $request"))
          .then((_) => _authorEventRepository.findAuthorsEvents(request));
}
