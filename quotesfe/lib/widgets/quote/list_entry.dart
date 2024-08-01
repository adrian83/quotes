import 'package:flutter/material.dart';

import 'package:quotesfe/widgets/common/list_entry.dart';
import 'package:quotesfe/paths.dart';
import 'package:quotes_common/domain/quote.dart';

class QuoteEntry extends ListEntry {
  final Quote _quote;
  final bool _detailsLink, _longDescription;

  const QuoteEntry(Key? key, this._quote, OnBackAction? onBackAction, bool showLabel, bool showId, this._detailsLink, this._longDescription)
      : super(key, "Quote", showLabel, showId, onBackAction);

  @override
  String deletePageUrl() => deleteQuotePath(_quote);

  @override
  String updatePageUrl() => updateQuotePath(_quote);

  @override
  String eventsPageUrl() => listQuoteEventsPath(_quote);

  @override
  String getId() => _quote.id;

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
    return () => Navigator.pushNamed(context, showQuotePath(_quote));
  }
}
