import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/author/service.dart';
import 'package:quotes_frontend/domain/book/service.dart';
import 'package:quotes_frontend/pages/common/show.dart';
import 'package:quotes_frontend/paths.dart';
import 'package:quotes_frontend/widgets/author/author_books.dart';
import 'package:quotes_frontend/widgets/author/list_entry.dart';
import 'package:quotes_common/domain/author.dart';

AuthorEntry authorToWidget(Author a) => AuthorEntry(null, a, null, true, true, false, true);

class ShowAuthorPage extends ShowPage<Author> {
  final AuthorService _authorService;
  final BookService _bookService;
  final String _authorId;

  const ShowAuthorPage(Key? key, String title, this._authorId, this._authorService, this._bookService) : super(key, title, authorToWidget);

  @override
  Future<Author> findEntity() => _authorService.find(_authorId);

  @override
  List<Widget> additionalWidgets() {
    return [AuthorBooks(UniqueKey(), _authorId, _bookService)];
  }

  @override
  String? createChildButtonLabel() => "Create new book";

  @override
  String? createChildPath() => createBookPath(_authorId);
}
