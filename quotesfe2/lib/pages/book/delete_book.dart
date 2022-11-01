import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/pages/common/delete.dart';

class DeleteBookPage extends DeletePage {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/delete/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String authorId, bookId;
  final BookService _bookService;

  const DeleteBookPage(
      Key? key, String title, this.authorId, this.bookId, this._bookService)
      : super(key, title);

  @override
  Future<void> deleteEntity() => _bookService.delete(authorId, bookId);

  @override
  String question() => "Are you sure?";

  @override
  String successMessage() => "Book removed";
}
