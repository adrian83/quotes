import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/model.dart';
import 'package:quotesfe2/pages/widgets/common.dart';

class BookEntry extends StatefulWidget {

  final Book _book;

  const BookEntry(Key? key, this._book) : super(key: key);

  @override
  State<BookEntry> createState() => _BookEntryState();
}

class _BookEntryState extends State<BookEntry> {

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Title: ${widget._book.title}'),
            Text('Description: ${widget._book.shortDescription}')
      ],
    );
  }
}

class BookPageEntry extends PageEntry<Book, BooksPage, BookEntry> {

const BookPageEntry(Key key, PageChangeAction<Book> pageChangeAction, ToEntryTransformer<Book, BookEntry> toEntryTransformer) 
: super(key, "Books", pageChangeAction, toEntryTransformer);

}
