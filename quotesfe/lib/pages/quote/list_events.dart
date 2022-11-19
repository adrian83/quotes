import 'package:flutter/material.dart';

import 'package:quotesfe/domain/quote/event.dart';
import 'package:quotesfe/domain/quote/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/pages/common/events.dart';
import 'package:quotesfe/domain/common/page.dart' as p;

class ListQuoteEventsPage extends ListEventsPage<QuoteEvent> {
  final String _authorId, _bookId, _quoteId;
  final QuoteService _bookService;

  const ListQuoteEventsPage(Key? key, String title, this._authorId,
      this._bookId, this._quoteId, this._bookService)
      : super(key, title);

  @override
  List<String> columns() => [
        "Event Id",
        "Operation",
        "Quote text",
        "Quote created",
        "Quote modified"
      ];

  @override
  List<Widget> eventToData(QuoteEvent event) => [
        Text(event.eventId),
        Text(event.operation),
        Text(event.text, maxLines: 10),
        Text(event.createdUtc.toIso8601String()),
        Text(event.modifiedUtc.toIso8601String())
      ];

  @override
  Future<p.Page<QuoteEvent>> getPage(PageRequest pageReq) =>
      _bookService.listEvents(_authorId, _bookId, _quoteId, pageReq);
}
