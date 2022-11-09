import 'package:flutter/material.dart';
import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/pages/widgets/author/list_entry.dart';

AuthorEntry authorToWidget(Author a) => AuthorEntry(null, a, true, false, true);

class ShowAuthorPage extends ShowPage<Author> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final AuthorService _authorService;
  final String entityId;

  const ShowAuthorPage(
      Key? key, String title, this.entityId, this._authorService)
      : super(key, title, authorToWidget);

  @override
  Future<Author> findEntity() => _authorService.find(entityId);
}