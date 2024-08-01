import 'package:flutter/material.dart';

import 'package:quotesfe/widgets/book/list_entry.dart';
import 'package:quotesfe/widgets/page_entry.dart';
import 'package:quotes_common/domain/book.dart';

class BookPageEntry extends PageEntry<Book, BooksPage, BookEntry> {
  const BookPageEntry(Key key, PageChangeAction<Book> pageChangeAction, ToEntryTransformer<Book, BookEntry> toEntryTransformer, ErrorHandler errorHandler)
      : super(key, "Books", pageChangeAction, toEntryTransformer, errorHandler);
}
