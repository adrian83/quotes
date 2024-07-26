import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/model.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/paths.dart';
import 'package:quotesfe/widgets/author/author_books.dart';
import 'package:quotesfe/widgets/author/list_entry.dart';

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
