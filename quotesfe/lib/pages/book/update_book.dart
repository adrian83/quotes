import 'package:flutter/material.dart';
import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/pages/book/new_book.dart';

class UpdateBookPage extends NewBookPage {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/update/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final String bookId;

  const UpdateBookPage(Key? key, String title, String authorId, this.bookId,
      BookService bookService)
      : super(key, title, authorId, bookService);

  @override
  NewBookEntityForm createEntityForm(BuildContext context, Book? entity) =>
      NewBookEntityForm(authorId, entity);

  @override
  String successMessage() => "Book updated";

  @override
  Future<Book?> init() => bookService.find(authorId, bookId);
}
