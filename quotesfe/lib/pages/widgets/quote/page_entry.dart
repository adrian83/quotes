import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/pages/widgets/common.dart';
import 'package:quotesfe/pages/widgets/quote/list_entry.dart';

class QuotePageEntry extends PageEntry<Quote, QuotesPage, QuoteEntry> {
  const QuotePageEntry(
      Key key,
      PageChangeAction<Quote> pageChangeAction,
      ToEntryTransformer<Quote, QuoteEntry> toEntryTransformer,
      ErrorHandler errorHandler)
      : super(
            key, "Quotes", pageChangeAction, toEntryTransformer, errorHandler);
}
