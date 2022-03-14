import 'package:flutter/material.dart';

import 'package:url_launcher/link.dart';

import 'package:quotesfe2/domain/author/model.dart';


class AuthorEntry extends StatefulWidget {

  final Author _author;

  const AuthorEntry(Key? key, this._author) : super(key: key);

  @override
  State<AuthorEntry> createState() => _AuthorEntryState();
}

class _AuthorEntryState extends State<AuthorEntry> {

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Id: ${widget._author.id}'),

            Link(
                uri: Uri.parse('/authors/show/${widget._author.id}'),
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return TextButton(
                    onPressed: openLink,
                    child: Text('Name: ${widget._author.name}'),
                  );
                },
              ),
            Text('Description: ${widget._author.shortDescription}')
      ],
    );
  }
}