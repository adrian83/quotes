import 'package:flutter/material.dart';

import 'package:quotesfe/widgets/common/list_entry.dart';
import 'package:quotesfe/paths.dart';
import 'package:quotes_common/domain/book.dart';

class BookEntry extends ListEntry {
  final Book _book;
  final bool _detailsLink, _longDescription;

  const BookEntry(Key? key, this._book, OnBackAction? onBackAction, bool showLabel, bool showId, this._detailsLink, this._longDescription)
      : super(key, "Book", showLabel, showId, onBackAction);

  @override
  String deletePageUrl() => deleteBookPath(_book);

  @override
  String updatePageUrl() => updateBookPath(_book);

  @override
  String eventsPageUrl() => listBookEventsPath(_book);

  @override
  String getId() => _book.id;

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
    return () => Navigator.pushNamed(context, showBookPath(_book));
  }
}
