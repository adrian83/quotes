import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/pages/widgets/book/list_entry.dart';
import 'package:quotesfe2/pages/widgets/common.dart';

class BookPageEntry extends PageEntry<Book, BooksPage, BookEntry> {
  const BookPageEntry(Key key, PageChangeAction<Book> pageChangeAction,
      ToEntryTransformer<Book, BookEntry> toEntryTransformer)
      : super(key, "Books", pageChangeAction, toEntryTransformer);
}
