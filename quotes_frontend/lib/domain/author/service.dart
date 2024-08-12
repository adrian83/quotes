import 'dart:async';

import 'package:http/browser_client.dart';

import 'package:quotes_frontend/domain/author/event.dart';
import 'package:quotes_frontend/domain/common/service.dart';
import 'package:quotes_frontend/tools/config.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/domain/page.dart';

class AuthorService extends Service<Author> {
  final String _apiHost;

  AuthorService(BrowserClient super.http, Config config) : _apiHost = config.apiHost;

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
