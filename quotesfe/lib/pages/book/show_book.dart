import 'package:flutter/material.dart';
import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/common.dart';
import 'package:quotesfe/pages/widgets/book/list_entry.dart';

BookEntry bookToWidget(Book b) => BookEntry(null, b, true, false, true);

class ShowBookPage extends ShowEntityPage<Book> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/show/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final BookService _bookService;
  final String bookId;
  final String authorId;

  const ShowBookPage(
      Key? key, String title, this.authorId, this.bookId, this._bookService)
      : super(key, title, bookToWidget);

  @override
  Future<Book> findEntity() => _bookService.find(authorId, bookId);
}
