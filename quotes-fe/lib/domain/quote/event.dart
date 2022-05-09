import 'model.dart';

import '../common/page.dart';

class QuoteEvent extends Quote {
  String _eventId, _operation;

  QuoteEvent(this._eventId, this._operation, Quote quote)
      : super(quote.id, quote.text, quote.authorId, quote.bookId, quote.modifiedUtc, quote.createdUtc);

  QuoteEvent.fromJson(Map<String, dynamic> json) : this(json["id"], json["operation"], Quote.fromJson(json["entity"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() => super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<QuoteEvent> _quoteEventJsonDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventsPage extends Page<QuoteEvent> {
  QuoteEventsPage(PageInfo info, List<QuoteEvent> elements) : super(info, elements);

  QuoteEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  QuoteEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_quoteEventJsonDecoder, json);
}
