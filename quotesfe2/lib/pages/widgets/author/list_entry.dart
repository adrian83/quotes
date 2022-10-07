import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:quotesfe2/domain/author/model.dart';

class AuthorEntry extends StatefulWidget {
  final Author _author;
  final bool _showId, _detailsLink, _longDescription;

  const AuthorEntry(Key? key, this._author, this._showId, this._detailsLink,
      this._longDescription)
      : super(key: key);

  @override
  State<AuthorEntry> createState() => _AuthorEntryState();
}

class _AuthorEntryState extends State<AuthorEntry> {
  @override
  Widget build(BuildContext context) {
    developer.log("building: ${widget._author.name}");

    var children = <Widget>[];
    if (widget._showId) {
      children.add(Text('Id: ${widget._author.id}'));
    }

    if (widget._detailsLink) {
      children.add(TextButton(
        onPressed: showDetails(context),
        child: Text('Name: ${widget._author.name}'),
      ));
    } else {
      children.add(
        Text('Name: ${widget._author.name}'),
      );
    }

    var desc = widget._longDescription
        ? widget._author.description
        : widget._author.shortDescription;
    children.add(Text('Description: $desc'));

    var buttons = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: showUpdate(context),
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: gotoDeletePage(context),
            child: const Text('Delete'),
          )
        ]);

    children.add(buttons);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Function()? showDetails(BuildContext context) {
    return () =>
        Navigator.pushNamed(context, "/authors/show/${widget._author.id}");
  }

  Function()? showUpdate(BuildContext context) {
    return () =>
        Navigator.pushNamed(context, "/authors/update/${widget._author.id}");
  }

  Function()? gotoDeletePage(BuildContext context) {
    return () =>
        Navigator.pushNamed(context, "/authors/delete/${widget._author.id}");
  }
}
