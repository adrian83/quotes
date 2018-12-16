import 'model.dart';

import '../common/page.dart';

class AuthorEvent extends Author {
  String _eventId, _operation;

  AuthorEvent(this._eventId, this._operation, String id, String name,
      String description, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, name, description, modifiedUtc, createdUtc);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : this(
            json["eventId"],
            json["operation"],
            json["id"],
            json["name"],
            json["description"],
            DateTime.parse(json["modifiedUtc"]),
            DateTime.parse(json["createdUtc"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() =>
      super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<AuthorEvent> _authorEventJsonDecoder =
    (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventsPage extends Page<AuthorEvent> {
  AuthorEventsPage(PageInfo info, List<AuthorEvent> elements)
      : super(info, elements);

  AuthorEventsPage.empty() : super(PageInfo(0, 0, 0), List<AuthorEvent>());

  AuthorEventsPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_authorEventJsonDecoder, json);
}
