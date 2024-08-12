import 'package:flutter/material.dart';

import 'package:quotes_frontend/domain/author/event.dart';
import 'package:quotes_frontend/domain/author/service.dart';
import 'package:quotes_frontend/pages/common/events.dart';
import 'package:quotes_common/domain/page.dart' as pg;

class ListAuthorEventsPage extends ListEventsPage<AuthorEvent> {
  final AuthorService _authorService;
  final String _authorId;

  const ListAuthorEventsPage(
    super.key,
    super.title,
    this._authorId,
    this._authorService,
  );

  @override
  List<String> columns() => ["Event Id", "Operation", "Author name", "Author desc", "Author created", "Author modified"];

  @override
  List<Widget> eventToData(AuthorEvent event) => [
        Text(event.eventId),
        Text(event.operation),
        Text(event.name),
        Text(event.description ?? "", maxLines: 10),
        Text(event.createdUtc.toIso8601String()),
        Text(event.modifiedUtc.toIso8601String())
      ];

  @override
  Future<pg.Page<AuthorEvent>> getPage(pg.PageRequest pageReq) => _authorService.listEvents(_authorId, pageReq);
}
