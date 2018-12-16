import '../common/page.dart';

class Quote {
  String _id, _text, _authorId, _bookId;
  DateTime _modifiedUtc, _createdUtc;

  Quote(this._id, this._text, this._authorId, this._bookId, this._modifiedUtc,
      this._createdUtc);

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
      json['id'],
      json['text'],
      json['authorId'],
      json['bookId'],
      DateTime.parse(json["modifiedUtc"]),
      DateTime.parse(json["createdUtc"]));

  factory Quote.empty() => Quote(
      null, "", null, null, DateTime.now().toUtc(), DateTime.now().toUtc());

  String get id => _id;
  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;

  void set text(String text) {
    this._text = text;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  void set bookId(String bookId) {
    this._bookId = bookId;
  }

  Map toJson() => {
        "id": _id,
        "text": _text,
        "authorId": _authorId,
        "bookId": _bookId,
        "modifiedUtc": _modifiedUtc.toIso8601String(),
        "createdUtc": _createdUtc.toIso8601String()
      };
}

JsonDecoder<Quote> _quoteJsonDecoder =
    (Map<String, dynamic> json) => Quote.fromJson(json);

class QuotesPage extends Page<Quote> {
  QuotesPage(PageInfo info, List<Quote> elements) : super(info, elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), List<Quote>());

  QuotesPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_quoteJsonDecoder, json);
}
