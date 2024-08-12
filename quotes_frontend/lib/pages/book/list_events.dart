import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/book/event.dart';
import 'package:quotes_frontend/domain/book/service.dart';
import 'package:quotes_frontend/pages/common/events.dart';
import 'package:quotes_common/domain/page.dart' as pg;

class ListBookEventsPage extends ListEventsPage<BookEvent> {
  final BookService _bookService;
  final String _authorId, _bookId;

  const ListBookEventsPage(super.key, super.title, this._authorId, this._bookId, this._bookService);

  @override
  List<String> columns() => ["Event Id", "Operation", "Book title", "Book desc", "Book created", "Book modified"];

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
  Future<pg.Page<BookEvent>> getPage(pg.PageRequest pageReq) => _bookService.listEvents(_authorId, _bookId, pageReq);
}
