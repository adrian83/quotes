import '../common/page.dart';

class Book {
  String _id, _title, _authorId, _bookId;

  Book(this._id, this._title, this._authorId, this._bookId);

  String get id => _id;
  String get title => _title;
  String get authorId => _authorId;
  String get bookId => _bookId;

  void set name(String title) {
    this._title = title;
  }

  factory Book.fromJson(Map<String, dynamic> json) =>
      new Book(json['id'], json['title'], json['authorId'], json['bookId']);

  Map toJson() => {
        "id": _id,
        "title": _title,
      };
}

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(new PageInfo(0, 0, 0), new List<Book>());

  factory BooksPage.fromJson(Map<String, dynamic> json) {
    var books =
        (json['elements'] as List).map((j) => new Book.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return new BooksPage(info, books);
  }
}
