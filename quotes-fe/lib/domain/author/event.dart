import 'model.dart';

import '../common/page.dart';

class AuthorEvent extends Author {
  String _eventId, _operation;

  AuthorEvent(this._eventId, this._operation, Author author)
      : super(author.id, author.name, author.description, author.modifiedUtc, author.createdUtc);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : this(json["id"], json["operation"], Author.fromJson(json["entity"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() => super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<AuthorEvent> _authorEventJsonDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventsPage extends Page<AuthorEvent> {
  AuthorEventsPage(PageInfo info, List<AuthorEvent> elements) : super(info, elements);

  AuthorEventsPage.empty() : super(PageInfo(0, 0, 0), List<AuthorEvent>());

  AuthorEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_authorEventJsonDecoder, json);
}
