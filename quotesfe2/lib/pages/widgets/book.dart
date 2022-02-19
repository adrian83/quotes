import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/model.dart';


class BookEntry extends StatefulWidget {

  Book _book;

  BookEntry(Key? key, this._book) : super(key: key);

  @override
  State<BookEntry> createState() => _BookEntryState(_book);
}

class _BookEntryState extends State<BookEntry> {

  Book _book;

  _BookEntryState(this._book);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Title: ${_book.title}'),
            Text('Description: ${_book.shortDescription}')
      ],
    );
  }
}