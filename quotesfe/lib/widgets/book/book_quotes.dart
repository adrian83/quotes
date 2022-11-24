import 'package:flutter/material.dart';

import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/quote/model.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/widgets/common/info_state.dart';
import 'package:quotesfe/widgets/quote/list_entry.dart';
import 'package:quotesfe/widgets/quote/page_entry.dart';

class BookQuotes extends StatefulWidget {
  final String _authorId, _bookId;
  final QuoteService _quoteService;

  const BookQuotes(Key? key, this._authorId, this._bookId, this._quoteService)
      : super(key: key);

  @override
  State<BookQuotes> createState() => _BookQuotesState();
}

class _BookQuotesState extends InfoState<BookQuotes> {
  late QuotePageEntry _quotesWidgets = _newQuotePageEntry();

  Future<QuotesPage> changeQuotesPage(PageRequest pageReq) =>
      widget._quoteService
          .listBookQuotes(widget._authorId, widget._bookId, pageReq);

  QuoteEntry _toQuoteEntry(Quote q) =>
      QuoteEntry(null, q, refresh, false, false, true, true);

  QuotePageEntry _newQuotePageEntry() {
    return QuotePageEntry(
        UniqueKey(), changeQuotesPage, _toQuoteEntry, errorHandler());
  }

  void refresh() {
    setState(() {
      _quotesWidgets = _newQuotePageEntry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _quotesWidgets;
  }
}
