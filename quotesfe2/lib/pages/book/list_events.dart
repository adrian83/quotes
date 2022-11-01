import 'package:flutter/material.dart';

import 'package:quotesfe2/domain/book/event.dart';
import 'package:quotesfe2/domain/book/service.dart';
import 'package:quotesfe2/domain/common/page.dart';
import 'package:quotesfe2/pages/common/events.dart';
import 'package:quotesfe2/domain/common/page.dart' as p;

class ListBookEventsPage extends ListEventsPage<BookEvent> {
  static String routePattern =
      r'^/authors/show/([a-zA-Z0-9_.-]*)/books/events/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final BookService _bookService;
  final String authorId, bookId;

  const ListBookEventsPage(
      Key? key, String title, this.authorId, this.bookId, this._bookService)
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
      _bookService.listEvents(authorId, bookId, pageReq);
}
