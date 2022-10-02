import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/pages/widgets/common.dart';

class AuthorEntry extends StatefulWidget {
  final Author _author;

  const AuthorEntry(Key? key, this._author) : super(key: key);

  @override
  State<AuthorEntry> createState() => _AuthorEntryState();
}

class _AuthorEntryState extends State<AuthorEntry> {
  @override
  Widget build(BuildContext context) {
    developer.log("building: ${widget._author.name}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Id: ${widget._author.id}'),
        TextButton(
          onPressed: () => Navigator.pushNamed(
              context, "/authors/show/${widget._author.id}"), 
          child: Text('Name: ${widget._author.name}'),
        ),
        Text('Description: ${widget._author.shortDescription}')
      ],
    );
  }
}

class AuthorPageEntry extends PageEntry<Author, AuthorsPage, AuthorEntry> {
  const AuthorPageEntry(
      Key? key,
      PageChangeAction<Author> pageChangeAction,
      ToEntryTransformer<Author, AuthorEntry> toEntryTransformer,
      EditEntityUrl<Author> onEditAction,
      OnDeleteAction<Author> onDeleteAction)
      : super(key, "Authors", pageChangeAction, toEntryTransformer,
            onEditAction, onDeleteAction);
}
