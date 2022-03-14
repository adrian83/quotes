import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/model.dart';


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