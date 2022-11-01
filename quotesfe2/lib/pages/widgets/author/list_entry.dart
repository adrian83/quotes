import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/author/model.dart';
import 'package:quotesfe2/pages/widgets/common/list_entry.dart';

class AuthorEntry extends ListEntry {
  final Author _author;
  final bool _detailsLink, _longDescription;

  const AuthorEntry(Key? key, this._author, bool showId, this._detailsLink,
      this._longDescription)
      : super(key, showId);

  @override
  String deletePageUrl() => "/authors/delete/${_author.id}";

  @override
  String updatePageUrl() => "/authors/update/${_author.id}";

  @override
  String eventsPageUrl() => "/authors/events/${_author.id}";

  @override
  String getId() => _author.id!;

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
      children.add(
        paddingWithText('Name: ${_author.name}'),
      );
    }

    var desc =
        _longDescription ? _author.description : _author.shortDescription;
    children.add(paddingWithText('Description: $desc'));

    return children;
  }

  Function()? gotoDetailsPage(BuildContext context) {
    return () => Navigator.pushNamed(context, "/authors/show/${_author.id}");
  }
}
