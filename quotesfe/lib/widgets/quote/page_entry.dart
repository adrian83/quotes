import 'package:flutter/material.dart';

import 'package:quotesfe/widgets/page_entry.dart';
import 'package:quotesfe/widgets/quote/list_entry.dart';
import 'package:quotes_common/domain/quote.dart';

class QuotePageEntry extends PageEntry<Quote, QuotesPage, QuoteEntry> {
  const QuotePageEntry(Key key, PageChangeAction<Quote> pageChangeAction, ToEntryTransformer<Quote, QuoteEntry> toEntryTransformer, ErrorHandler errorHandler)
      : super(key, "Quotes", pageChangeAction, toEntryTransformer, errorHandler);
}
