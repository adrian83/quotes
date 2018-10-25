import '../common/page.dart';

class Book {
  String _id, _title;

  Book(this._id, this._title);

  String get id => _id;
  String get title => _title;

  void set name(String title) {
    this._title = title;
  }

  factory Book.fromJson(Map<String, dynamic> author) =>
      new Book(author['id'], author['title']);

  Map toJson() {
    var map = new Map<String, Object>();
    map["id"] = _id;
    map["title"] = _title;
    return map;
  }
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
