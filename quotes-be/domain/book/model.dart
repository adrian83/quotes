import '../common/model.dart';

class Book extends Entity {
  String _title, _authorId;

  Book(String id, this._title, this._authorId) : super(id);

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(json['id'], json['title'], json['authorId']);

  String get title => _title;
  String get authorId => _authorId;

  Map toJson() {
    var map = super.toJson();
    map.addAll({
      "title": _title,
      "authorId": _authorId,
    });
    return map;
  }
}
