import 'package:uuid/uuid.dart';

import '../common/model.dart';

import '../../store/document.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId,
      [DateTime createdUtc])
      : super(id, DateTime.now().toUtc());

  factory Quote.fromJson(Map<String, dynamic> json) =>
      Quote(json['id'], json['text'], json['authorId'], json['bookId']);

  factory Quote.fromDB(List<dynamic> row) => Quote(row[0].toString().trim(),
      row[1].toString().trim(), row[2].toString().trim(), row[3].toString().trim(), row[4]);

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  Quote generateId() {
    id = Uuid().v4();
    return this;
  }

  Map toJson() => super.toJson()
    ..addAll({
      "text": _text,
      "authorId": _authorId,
      "bookId": _bookId,
    });
}

class QuoteEvent extends ESDocument {
  Quote _quote;

  QuoteEvent(String docId, String operation, this._quote)
      : super(docId, operation);

  factory QuoteEvent.created(String docId, Quote quote) =>
      QuoteEvent(docId, ESDocument.created, quote);

  factory QuoteEvent.modified(String docId, Quote quote) =>
      QuoteEvent(docId, ESDocument.modified, quote);

  factory QuoteEvent.deleted(String docId, Quote quote) =>
      QuoteEvent(docId, ESDocument.deleted, quote);

  factory QuoteEvent.fromJson(Map<String, dynamic> json) =>
      QuoteEvent(json['docId'], json['operation'], Quote.fromJson(json));

  Quote get quote => _quote;

  Map toJson() => super.toJson()..addAll(_quote.toJson());
}
