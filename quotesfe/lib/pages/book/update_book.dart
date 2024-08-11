import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/book/new_book.dart';
import 'package:quotes_common/domain/book.dart';

class UpdateBookPage extends NewBookPage {
  final String _bookId;

  const UpdateBookPage(Key? key, String title, String authorId, this._bookId, BookService bookService) : super(key, title, authorId, bookService);

  @override
  NewBookEntityForm createEntityForm(BuildContext context, Book? entity) => NewBookEntityForm(authorId, entity);

  @override
  String successMessage() => "Book updated";

  @override
  Future<Book?> init() => bookService.find(authorId, _bookId);
}
