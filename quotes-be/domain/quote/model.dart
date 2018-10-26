import '../common/model.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId) : super(id);

  factory Quote.fromJson(Map<String, dynamic> json) =>
      Quote(json['id'], json['text'], json['authorId'], json['bookId']);

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  Map toJson() => {
        "text": _text,
        "authorId": _authorId,
        "bookId": _bookId,
      };
}
