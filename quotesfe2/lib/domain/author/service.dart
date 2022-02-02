import 'dart:async';

import 'package:http/browser_client.dart';

import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/domain/author/event.dart';
import 'package:quotesfe2/domain/common/service.dart';
import 'package:quotesfe2/domain/common/page.dart';
import 'package:quotesfe2/tools/config.dart';

class AuthorService extends Service<Author> {
  final Config _config;

  AuthorService(BrowserClient http, this._config) : super(http);

  Future<AuthorsPage> listAuthors(String searchPhrase, PageRequest request) => Future.value(request)
      .then((req) => pageRequestToUrlParams(req))
      .then((params) => appendUrlParam(params, "searchPhrase", searchPhrase))
      .then((urlParams) => "${_config.beHost}/authors?$urlParams")
      .then((url) => getEntity(url))
      .then((json) => AuthorsPage.fromJson(json));

  Future<AuthorEventsPage> listEvents(String authorId, PageRequest request) {
    var url = "${_config.beHost}/authors/$authorId/events?${pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => AuthorEventsPage.fromJson(json));
  }

  Future<Author> create(Author author) {
    var url = "${_config.beHost}/authors";
    return createEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> update(Author author) {
    var url = "${_config.beHost}/authors/${author.id}";
    return updateEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> find(String id) {
    var url = "${_config.beHost}/authors/$id";
    return getEntity(url).then((json) => Author.fromJson(json));
  }

  Future<String> delete(String id) {
    var url = "${_config.beHost}/authors/$id";
    return deleteEntity(url).then((_) => id);
  }
}
