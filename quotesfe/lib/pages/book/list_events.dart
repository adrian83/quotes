import 'package:flutter/material.dart';

import 'package:quotesfe/domain/book/event.dart';
import 'package:quotesfe/domain/book/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/pages/common/events.dart';
import 'package:quotesfe/domain/common/page.dart' as p;

class ListBookEventsPage extends ListEventsPage<BookEvent> {
  final BookService _bookService;
  final String _authorId, _bookId;

  const ListBookEventsPage(
      Key? key, String title, this._authorId, this._bookId, this._bookService)
      : super(key, title);

  @override
  List<String> columns() => [
        "Event Id",
        "Operation",
        "Book title",
        "Book desc",
        "Book created",
        "Book modified"
      ];

  @override
  List<Widget> eventToData(BookEvent event) => [
        Text(event.eventId),
        Text(event.operation),
        Text(event.title),
        Text(event.description ?? "", maxLines: 10),
        Text(event.createdUtc.toIso8601String()),
        Text(event.modifiedUtc.toIso8601String())
      ];

  @override
  Future<p.Page<BookEvent>> getPage(PageRequest pageReq) =>
      _bookService.listEvents(_authorId, _bookId, pageReq);
}
