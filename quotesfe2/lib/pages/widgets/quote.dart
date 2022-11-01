import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/pages/widgets/common.dart';
import 'package:quotesfe2/pages/widgets/quote/list_entry.dart';

class QuotePageEntry extends PageEntry<Quote, QuotesPage, QuoteEntry> {
  const QuotePageEntry(Key key, PageChangeAction<Quote> pageChangeAction,
      ToEntryTransformer<Quote, QuoteEntry> toEntryTransformer)
      : super(key, "Quotes", pageChangeAction, toEntryTransformer);
}
