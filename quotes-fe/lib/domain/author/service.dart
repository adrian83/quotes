import 'dart:async';

import 'package:http/browser_client.dart';

import 'model.dart';
import 'event.dart';

import '../common/service.dart';
import '../common/page.dart';

class AuthorService extends Service<Author> {
  static final String _host = "http://localhost:5050";

  AuthorService(BrowserClient http) : super(http);

  Future<AuthorsPage> list(PageRequest request, [String searchPhrase]) => Future.value(request)
      .then((req) => pageRequestToUrlParams(req))
      .then((urlParams) => appendUrlParam(urlParams, "searchPhrase", searchPhrase))
      .then((urlParams) => "$_host/authors?$urlParams")
      .then((url) => getEntity(url))
      .then((json) => AuthorsPage.fromJson(json));

  Future<AuthorEventsPage> listEvents(String authorId, PageRequest request) {
    var url =
        "$_host/authors/${authorId}/events?${this.pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => AuthorEventsPage.fromJson(json));
  }

  Future<Author> create(Author author) {
    var url = "$_host/authors";
    return createEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> update(Author author) {
    var url = "$_host/authors/${author.id}";
    return updateEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> get(String id) {
    var url = "$_host/authors/$id";
    return getEntity(url).then((json) => Author.fromJson(json));
  }

  Future<String> delete(String id) {
    var url = "$_host/authors/$id";
    return deleteEntity(url).then((_) => id);
  }
}
