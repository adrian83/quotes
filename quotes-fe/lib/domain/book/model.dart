import '../common/page.dart';

class Book {
  String _id, _title, _authorId;

  Book(this._id, this._title, this._authorId);

  factory Book.fromJson(Map<String, dynamic> json) =>
      new Book(json['id'], json['title'], json['authorId']);

  String get id => _id;
  String get title => _title;
  String get authorId => _authorId;

  void set title(String title) {
    this._title = title;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  Map toJson() => {
        "id": _id,
        "title": _title,
        "authorId": _authorId,
      };
}

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(new PageInfo(0, 0, 0), new List<Book>());

  factory BooksPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var books = elems.map((j) => Book.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return new BooksPage(info, books);
  }
}
