import '../common/model.dart';

class Quote extends Entity {
  String _text, _authorId, _bookId;

  Quote(String id, this._text, this._authorId, this._bookId) : super(id);

  String get text => _text;
  String get authorId => _authorId;
  String get bookId => _bookId;

  Map toJson() {
    var map = super.toJson();
    map["text"] = this.text;
    map["authorId"] = this.authorId;
    map["bookId"] = this.bookId;
    return map;
  }
}
