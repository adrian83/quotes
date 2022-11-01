import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/pages/widgets/common/list_entry.dart';

class QuoteEntry extends ListEntry {
  final Quote _quote;
  final bool _detailsLink, _longDescription;

  const QuoteEntry(Key? key, this._quote, bool showId, this._detailsLink,
      this._longDescription)
      : super(key, showId);

  @override
  String deletePageUrl() =>
      "/authors/show/${_quote.authorId}/books/show/${_quote.bookId}/quotes/delete/${_quote.id}";

  @override
  String updatePageUrl() =>
      "/authors/show/${_quote.authorId}/books/show/${_quote.bookId}/quotes/update/${_quote.id}";

  @override
  String eventsPageUrl() =>
      "/authors/show/${_quote.authorId}/books/show/${_quote.bookId}/quotes/events/${_quote.id}";

  @override
  String getId() => _quote.id!;

  @override
  List<Widget> widgets(BuildContext context) {
    var lines = _longDescription ? _quote.textLines : _quote.shortLines;
    var widgets = lines.map((line) => paddingWithText(line)).toList();

    if (_detailsLink) {
      return widgets
          .map((txt) => TextButton(
                onPressed: gotoDetailsPage(context),
                child: txt,
              ))
          .toList();
    }
    return widgets;
  }

  Function()? gotoDetailsPage(BuildContext context) {
    return () => Navigator.pushNamed(context,
        "/authors/show/${_quote.authorId}/books/show/${_quote.bookId}/quotes/show/${_quote.id}");
  }
}
