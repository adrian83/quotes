import 'dart:async';

import 'package:http/browser_client.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/author/event.dart';
import 'package:quotesfe/domain/common/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/tools/config.dart';

class AuthorService extends Service<Author> {
  final String _apiHost;

  AuthorService(BrowserClient http, Config config)
      : _apiHost = config.apiHost,
        super(http);

  Future<AuthorsPage> listAuthors(String searchPhrase, PageRequest request) async {
    var urlParams = pageRequestToUrlParams(request);
    var urlParamsWithSearchPhrase = appendUrlParam(urlParams, paramSearchPhrase, searchPhrase);
    var url = "$_apiHost/authors?$urlParamsWithSearchPhrase";
    var jsonEntity = await getEntity(url);
    return AuthorsPage.fromJson(jsonEntity);
  }

  Future<AuthorEventsPage> listEvents(String authorId, PageRequest request) {
    var urlParams = pageRequestToUrlParams(request);
    var url = "$_apiHost/authors/$authorId/events?$urlParams";
    return getEntity(url).then((json) => AuthorEventsPage.fromJson(json));
  }

  Future<Author> create(Author author) {
    var url = "$_apiHost/authors";
    return createEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> update(Author author) {
    var url = "$_apiHost/authors/${author.id}";
    return updateEntity(url, author).then((json) => Author.fromJson(json));
  }

  Future<Author> find(String id) {
    var url = "$_apiHost/authors/$id";
    return getEntity(url).then((json) => Author.fromJson(json));
  }

  Future<String> delete(String id) {
    var url = "$_apiHost/authors/$id";
    return deleteEntity(url).then((_) => id);
  }
}
