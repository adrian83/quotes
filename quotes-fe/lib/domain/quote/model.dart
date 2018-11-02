import '../common/page.dart';

class Quote {
  String _id, _text, _authorId, _bookId;

  Quote(this._id, this._text, this._authorId, this._bookId);

  factory Quote.fromJson(Map<String, dynamic> json) =>
      Quote(json['id'], json['text'], json['authorId'], json['bookId']);

  factory Quote.empty() => Quote(null, "", null, null);

  String get id => _id;
  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  void set text(String text) {
    this._text = text;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  void set bookId(String bookId) {
    this._bookId = bookId;
  }

  Map toJson() =>
      {"id": _id, "text": _text, "authorId": _authorId, "bookId": _bookId};
}

class QuotesPage extends Page<Quote> {
  QuotesPage(PageInfo info, List<Quote> elements) : super(info, elements);

  QuotesPage.empty() : super(PageInfo(0, 0, 0), List<Quote>());

  factory QuotesPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var quotes = elems.map((j) => Quote.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return QuotesPage(info, quotes);
  }
}
