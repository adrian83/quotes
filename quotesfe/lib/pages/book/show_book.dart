import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/paths.dart';
import 'package:quotesfe/widgets/book/book_quotes.dart';
import 'package:quotesfe/widgets/book/list_entry.dart';
import 'package:quotes_common/domain/book.dart';

BookEntry _bookToWidget(Book b) => BookEntry(null, b, null, true, true, false, true);

class ShowBookPage extends ShowPage<Book> {
  final String _authorId, _bookId;
  final BookService _bookService;
  final QuoteService _quoteService;

  const ShowBookPage(Key? key, String title, this._authorId, this._bookId, this._bookService, this._quoteService) : super(key, title, _bookToWidget);

  @override
  Future<Book> findEntity() => _bookService.find(_authorId, _bookId);

  @override
  List<Widget> additionalWidgets() {
    return [BookQuotes(UniqueKey(), _authorId, _bookId, _quoteService)];
  }

  @override
  String? createChildButtonLabel() => "Create new quote";

  @override
  String? createChildPath() => createQuotePath(_authorId, _bookId);
}
