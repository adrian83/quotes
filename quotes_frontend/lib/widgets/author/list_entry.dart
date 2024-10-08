import 'package:flutter/material.dart';

import 'package:quotes_frontend/widgets/common/list_entry.dart';
import 'package:quotes_frontend/paths.dart';
import 'package:quotes_common/domain/author.dart';

class AuthorEntry extends ListEntry {
  final Author _author;
  final bool _detailsLink, _longDescription;

  const AuthorEntry(Key? key, this._author, OnBackAction? onBackAction, bool showLabel, bool showId, this._detailsLink, this._longDescription)
      : super(key, "Author", showLabel, showId, onBackAction);

  @override
  String deletePageUrl() => deleteAuthorPath(_author);

  @override
  String updatePageUrl() => updateAuthorPath(_author);

  @override
  String eventsPageUrl() => listAuthorEventsPath(_author);

  @override
  String getId() => _author.id;

  @override
  List<Widget> widgets(BuildContext context) {
    var children = <Widget>[];

    if (_detailsLink) {
      var button = TextButton(
        onPressed: gotoDetailsPage(context),
        child: Text('Name: ${_author.name}'),
      );
      paddingWithWidget(button);

      children.add(paddingWithWidget(button));
    } else {
      children.add(paddingWithText('Name: ${_author.name}'));
    }

    var desc = _longDescription ? _author.description : _author.shortDescription;
    children.add(paddingWithText('Description: $desc'));

    return children;
  }

  Function()? gotoDetailsPage(BuildContext context) {
    return () => Navigator.pushNamed(context, showAuthorPath(_author));
  }
}
