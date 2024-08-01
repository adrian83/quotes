import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/pages/common/show.dart';
import 'package:quotesfe/widgets/quote/list_entry.dart';
import 'package:quotes_common/domain/quote.dart';

QuoteEntry quoteToWidget(Quote q) => QuoteEntry(null, q, null, true, true, false, true);

class ShowQuotePage extends ShowPage<Quote> {
  final String _authorId, _bookId, _quoteId;
  final QuoteService _quoteService;

  const ShowQuotePage(Key? key, String title, this._authorId, this._bookId, this._quoteId, this._quoteService) : super(key, title, quoteToWidget);

  @override
  Future<Quote> findEntity() => _quoteService.find(_authorId, _bookId, _quoteId);

  @override
  List<Widget> additionalWidgets() => [];

  @override
  String? createChildButtonLabel() => null;

  @override
  String? createChildPath() => null;
}
