import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/pages/widgets/common/list_entry.dart';

class BookEntry extends ListEntry {
  final Book _book;
  final bool _detailsLink, _longDescription;

  const BookEntry(Key? key, this._book, bool showId, this._detailsLink,
      this._longDescription)
      : super(key, showId);

  @override
  String deletePageUrl() =>
      "/authors/show/${_book.authorId}/books/delete/${_book.id}";

  @override
  String updatePageUrl() =>
      "/authors/show/${_book.authorId}/books/update/${_book.id}";

  @override
  String eventsPageUrl() =>
      '/authors/show/${_book.authorId}/books/events/${_book.id}';

  @override
  String getId() => _book.id!;

  @override
  List<Widget> widgets(BuildContext context) {
    var children = <Widget>[];

    var titleText = Text('Name: ${_book.title}');

    if (_detailsLink) {
      var button = TextButton(
        onPressed: gotoDetailsPage(context),
        child: titleText,
      );
      children.add(paddingWithWidget(button));
    } else {
      children.add(paddingWithWidget(titleText));
    }

    var desc = _longDescription ? _book.description : _book.shortDescription;
    children.add(paddingWithText('Description: $desc'));

    return children;
  }

  Function()? gotoDetailsPage(BuildContext context) {
    return () => Navigator.pushNamed(
        context, "/authors/show/${_book.authorId}/books/show/${_book.id}");
  }
}
