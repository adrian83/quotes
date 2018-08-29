import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';

class ListAuthorsHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  ListAuthorsHandler(this._authorService) : super(_URL, "GET") {}

  void execute(HttpRequest request) {
    var quotes = _authorService.findAuthors();
    ok(quotes, request);
  }
}
