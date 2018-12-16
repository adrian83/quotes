import 'model.dart';

import '../common/page.dart';

class BookEvent extends Book {
  String _eventId, _operation;

  BookEvent(
      this._eventId,
      this._operation,
      String id,
      String title,
      String description,
      String authorId,
      DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, title, description, authorId, modifiedUtc, createdUtc);

  factory BookEvent.fromJson(Map<String, dynamic> json) => BookEvent(
      json["eventId"],
      json["operation"],
      json["id"],
      json["title"],
      json["description"],
      json["authorId"],
      DateTime.parse(json["modifiedUtc"]),
      DateTime.parse(json["createdUtc"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() =>
      super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<BookEvent> _bookEventJsonDecoder =
    (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventsPage extends Page<BookEvent> {
  BookEventsPage(PageInfo info, List<BookEvent> elements)
      : super(info, elements);

  BookEventsPage.empty() : super(PageInfo(0, 0, 0), List<BookEvent>());

  BookEventsPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookEventJsonDecoder, json);
}
