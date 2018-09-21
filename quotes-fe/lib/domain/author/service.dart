import 'dart:async';

import 'package:http/browser_client.dart';
import 'model.dart';

import '../common/service.dart';
import '../common/page.dart';

class AuthorService extends Service<Author> {
  //static final _headers = {'Content-Type': 'application/json'};
  //static const _authorsUrl = 'http://localhost:5050/authors';
  //static const _authorUrl = 'http://localhost:5050/authors/';
  //final BrowserClient _http;

  static final String _host = "http://localhost:5050";
static final String _authors = "authors";

  AuthorService(BrowserClient http) : super(http);

  Future<AuthorsPage> list(PageRequest request) async {
    //LOGGER.info("Get authors. Request params: $request");
    var url = listUrl(_host, _authors, this.pageRequestToUrlParams(request));
    var jsonPage = await getEntity(url);
    return new AuthorsPage.fromJson(jsonPage);
  }

  Future<Author> create(Author author) async {
    //LOGGER.info("Create author: $author");
    var url = createUrl(_host, _authors);
    var json = await createEntity(url, author);
    return new Author.fromJson(json);
  }

  Future<Author> update(Author author) async {
    //LOGGER.info("Update author: $author");
    var url = updateUrl(_host, _authors, author.id);
    var json = await updateEntity(url, author);
    return new Author.fromJson(json);
  }

  Future<Author> get(String id) async {
    //LOGGER.info("Get author with id: $id");
    var url = getUrl(_host, _authors, id);
    var json = await getEntity(url);
    return new Author.fromJson(json);
  }

  Future<Null> delete(String id) async {
    //LOGGER.info("Delete author with id: $id");
    var url = deleteUrl(_host, _authors, id);
    //LOGGER.info("Url : $url");
    await deleteEntity(url);
  }

}
