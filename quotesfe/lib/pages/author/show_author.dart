import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/pages/widgets/author/list_entry.dart';

AuthorEntry authorToWidget(Author a) =>
    AuthorEntry(null, a, null, true, false, true);

class ShowAuthorPage extends ShowPage<Author> {
  final AuthorService _authorService;
  final String _authorId;

  const ShowAuthorPage(
      Key? key, String title, this._authorId, this._authorService)
      : super(key, title, authorToWidget);

  @override
  Future<Author> findEntity() => _authorService.find(_authorId);
}
