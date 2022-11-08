import 'package:flutter/material.dart';

import 'package:quotesfe/domain/author/event.dart';
import 'package:quotesfe/domain/author/service.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/pages/common/events.dart';
import 'package:quotesfe/domain/common/page.dart' as p;

class ListAuthorEventsPage extends ListEventsPage<AuthorEvent> {
  static String routePattern =
      r'^/authors/events/([a-zA-Z0-9_.-]*)/?(&[\w-=]+)?$';

  final AuthorService _authorService;
  final String authorId;

  const ListAuthorEventsPage(
    Key? key,
    String title,
    this.authorId,
    this._authorService,
  ) : super(key, title);

  @override
  List<String> columns() => [
        "Event Id",
        "Operation",
        "Author name",
        "Author desc",
        "Author created",
        "Author modified"
      ];

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
  Future<p.Page<AuthorEvent>> getPage(PageRequest pageReq) =>
      _authorService.listEvents(authorId, pageReq);
}
