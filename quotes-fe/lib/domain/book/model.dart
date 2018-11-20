import '../common/page.dart';

import '../../tools/strings.dart';

class Book {
  String _id, _title, _description, _authorId;

  Book(this._id, this._title, this._description, this._authorId);

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(json['id'], json['title'], json['description'], json['authorId']);

  factory Book.empty() => Book(null, "", "", null);

  String get id => _id;
  String get title => _title;
  String get description => _description;
  List<String> get descriptionParts => _description.split("\n");
  String get shortDescription => shorten(_description, 250);
  String get authorId => _authorId;

  void set title(String title) {
    this._title = title;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  void set description(String desc) {
    this._description = desc;
  }

  Map toJson() => {
        "id": _id,
        "title": _title,
        "authorId": _authorId,
        "description": _description,
      };
}

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), List<Book>());

  factory BooksPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var books = elems.map((j) => Book.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return BooksPage(info, books);
  }
}
