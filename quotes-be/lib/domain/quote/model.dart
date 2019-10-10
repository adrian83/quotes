import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, DateTime.now().toUtc());

  Quote.create(this._text, this._authorId, this._bookId) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.update(String id, this._text, this._authorId, this._bookId) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(json['id'], json['text'], json['authorId'], json['bookId'], DateTime.parse(json['modifiedUtc']), DateTime.parse(json['createdUtc']));

  Quote.fromDB(List<dynamic> row)
      : this(row[0].toString().trim(), row[1].toString().trim(), row[2].toString().trim(), row[3].toString().trim(), row[4], row[5]);

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

  QuoteEvent(String docId, String operation, this._quote) : super(docId, operation);

  QuoteEvent.created(String docId, Quote quote) : this(docId, ESDocument.created, quote);

  QuoteEvent.modified(String docId, Quote quote) : this(docId, ESDocument.modified, quote);

  QuoteEvent.deleted(String docId, Quote quote) : this(docId, ESDocument.deleted, quote);

  QuoteEvent.fromJson(Map<String, dynamic> json) : this(json['docId'], json['operation'], Quote.fromJson(json));

  Quote get quote => _quote;

  Map toJson() => super.toJson()..addAll(_quote.toJson());
}
