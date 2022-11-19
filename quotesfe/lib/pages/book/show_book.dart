import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/pages/widgets/book/list_entry.dart';

BookEntry _bookToWidget(Book b) => BookEntry(null, b, null, true, false, true);

class ShowBookPage extends ShowPage<Book> {
  final String _authorId, _bookId;
  final BookService _bookService;

  const ShowBookPage(
      Key? key, String title, this._authorId, this._bookId, this._bookService)
      : super(key, title, _bookToWidget);

  @override
  Future<Book> findEntity() => _bookService.find(_authorId, _bookId);
}
