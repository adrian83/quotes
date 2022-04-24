import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/pages/widgets/common.dart';

class QuoteEntry extends StatefulWidget {

  final Quote _quote;

  const QuoteEntry(Key? key, this._quote) : super(key: key);

  @override
  State<QuoteEntry> createState() => _QuoteEntryState();
}

class _QuoteEntryState extends State<QuoteEntry> {

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            Text('Text: ${widget._quote.shortLines}')
        ],
      );
  }
}

class QuotePageEntry extends PageEntry<Quote, QuotesPage, QuoteEntry> {

const QuotePageEntry(Key key, PageChangeAction<Quote> pageChangeAction, ToEntryTransformer<Quote, QuoteEntry> toEntryTransformer) 
: super(key, "Quotes", pageChangeAction, toEntryTransformer);

}

