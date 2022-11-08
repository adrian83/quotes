import 'model.dart';

import 'package:quotesfe/domain/common/page.dart';

class AuthorEvent extends Author {
  String eventId, operation;

  AuthorEvent(this.eventId, this.operation, Author author)
      : super(author.id, author.name, author.description, author.modifiedUtc,
            author.createdUtc);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : this(json["id"], json["operation"], Author.fromJson(json["entity"]));

  @override
  Map toJson() =>
      super.toJson()..addAll({"eventId": eventId, "operation": operation});
}

JsonDecoder<AuthorEvent> _authorEventJsonDecoder =
    (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventsPage extends Page<AuthorEvent> {
  AuthorEventsPage(PageInfo info, List<AuthorEvent> elements)
      : super(info, elements);

  AuthorEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  AuthorEventsPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_authorEventJsonDecoder, json);
}
