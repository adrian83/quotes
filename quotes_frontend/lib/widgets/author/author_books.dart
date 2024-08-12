import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/book/service.dart';
import 'package:quotes_frontend/widgets/book/list_entry.dart';
import 'package:quotes_frontend/widgets/book/page_entry.dart';
import 'package:quotes_frontend/widgets/common/info_state.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/domain/page.dart';

class AuthorBooks extends StatefulWidget {
  final String _authorId;
  final BookService _bookService;

  const AuthorBooks(Key? key, this._authorId, this._bookService) : super(key: key);

  @override
  State<AuthorBooks> createState() => _AuthorBooksState();
}

class _AuthorBooksState extends InfoState<AuthorBooks> {
  late BookPageEntry _booksWidgets = _newBookPageEntry();

  Future<BooksPage> changeBooksPage(PageRequest pageReq) => widget._bookService.listAuthorBooks(widget._authorId, pageReq);

  BookEntry _toBookEntry(Book b) => BookEntry(null, b, refresh, false, false, true, true);

  BookPageEntry _newBookPageEntry() {
    return BookPageEntry(UniqueKey(), changeBooksPage, _toBookEntry, errorHandler());
  }

  void refresh() {
    setState(() {
      _booksWidgets = _newBookPageEntry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _booksWidgets;
  }
}
