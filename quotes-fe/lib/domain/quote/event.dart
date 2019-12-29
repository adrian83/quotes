import 'model.dart';

import '../common/page.dart';

class QuoteEvent extends Quote {
  String _eventId, _operation;

  QuoteEvent(this._eventId, this._operation, String id, String text, String authorId, String bookId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, text, authorId, bookId, modifiedUtc, createdUtc);

  factory QuoteEvent.fromJson(Map<String, dynamic> json) => QuoteEvent(json["eventId"], json["operation"], json["id"], json["text"], json["authorId"],
      json["bookId"], DateTime.parse(json["modifiedUtc"]), DateTime.parse(json["createdUtc"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() => super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<QuoteEvent> _quoteEventJsonDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventsPage extends Page<QuoteEvent> {
  QuoteEventsPage(PageInfo info, List<QuoteEvent> elements) : super(info, elements);

  QuoteEventsPage.empty() : super(PageInfo(0, 0, 0), List<QuoteEvent>());

  QuoteEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_quoteEventJsonDecoder, json);
}
