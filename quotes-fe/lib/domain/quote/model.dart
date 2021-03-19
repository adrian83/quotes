import '../common/page.dart';
import '../common/model.dart';

import '../../tools/strings.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Quote.fromJson(Map<String, dynamic> json)
      : this(json['id'], json['text'], json['authorId'], json['bookId'], DateTime.parse(json["modifiedUtc"]), DateTime.parse(json["createdUtc"]));

  Quote.empty() : this(null, "", null, null, nowUtc(), nowUtc());

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;
  List<String> get textParts => _text.split("\n");
  List<String> get shortParts => shorten(_text, 80).split("\n");

  void set text(String text) {
    this._text = text;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  void set bookId(String bookId) {
    this._bookId = bookId;
  }

  Map toJson() => super.toJson()..addAll({"text": _text, "authorId": _authorId, "bookId": _bookId});
}

JsonDecoder<Quote> _quoteJsonDecoder = (Map<String, dynamic> json) => Quote.fromJson(json);

class QuotesPage extends Page<Quote> {
  QuotesPage(PageInfo info, List<Quote> elements) : super(info, elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), List<Quote>());

  QuotesPage.fromJson(Map<String, dynamic> json) : super.fromJson(_quoteJsonDecoder, json);
}
