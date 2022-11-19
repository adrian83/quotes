import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/pages/widgets/book/list_entry.dart';
import 'package:quotesfe/pages/widgets/common.dart';

class BookPageEntry extends PageEntry<Book, BooksPage, BookEntry> {
  const BookPageEntry(
      Key key,
      PageChangeAction<Book> pageChangeAction,
      ToEntryTransformer<Book, BookEntry> toEntryTransformer,
      ErrorHandler errorHandler)
      : super(key, "Books", pageChangeAction, toEntryTransformer, errorHandler);
}
