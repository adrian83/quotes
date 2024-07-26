import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/quote/model.dart';

class QuoteEvent extends Quote {
  final String _eventId, _operation;

  QuoteEvent(this._eventId, this._operation, Quote quote) : super(quote.id, quote.text, quote.authorId, quote.bookId, quote.modifiedUtc, quote.createdUtc);

  QuoteEvent.fromJson(Map<String, dynamic> json) : this(json[fieldEventId], json[fieldEventOperation], Quote.fromJson(json[fieldEventEntity]));

  String get eventId => _eventId;
  String get operation => _operation;

  @override
  Map toJson() => super.toJson()..addAll({fieldEventEventId: _eventId, fieldEventOperation: _operation});
}

JsonDecoder<QuoteEvent> _quoteEventJsonDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventsPage extends Page<QuoteEvent> {
  QuoteEventsPage(PageInfo info, List<QuoteEvent> elements) : super(info, elements);

  QuoteEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  QuoteEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_quoteEventJsonDecoder, json);
}
