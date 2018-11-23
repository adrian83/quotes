import '../common/model.dart';

import '../../store/document.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId, [DateTime createdUtc]) : super(id, createdUtc);

  factory Quote.fromJson(Map<String, dynamic> json) =>
      Quote(json['id'], json['text'], json['authorId'], json['bookId']);

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  Map toJson() => super.toJson()
    ..addAll({
      "text": _text,
      "authorId": _authorId,
      "bookId": _bookId,
    });
}

class QuoteEvent extends Quote implements ESDocument {

  QuoteEvent(Quote quote)
      : super(quote.id, quote.text, quote.authorId, quote.bookId, quote.createdUtc);
}
