import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/model.dart';


class AuthorEntry extends StatefulWidget {

  Author author;

  AuthorEntry(Key? key, this.author) : super(key: key);

  @override
  State<AuthorEntry> createState() => _AuthorEntryState(author);
}

class _AuthorEntryState extends State<AuthorEntry> {

  Author author;

  _AuthorEntryState(this.author);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Id: ${author.id}'),
            Text('Name: ${author.name}'),
            Text('Description: ${author.shortDescription}')
      ],
    );
  }
}