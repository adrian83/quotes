import 'model.dart';

import 'package:quotesfe2/domain/common/page.dart';

class BookEvent extends Book {
  String _eventId, _operation;

  BookEvent(this._eventId, this._operation, Book book)
      : super(book.id, book.title, book.description, book.authorId, book.modifiedUtc, book.createdUtc);

  BookEvent.fromJson(Map<String, dynamic> json) : this(json["id"], json["operation"], Book.fromJson(json["entity"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() => super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

JsonDecoder<BookEvent> _bookEventJsonDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventsPage extends Page<BookEvent> {
  BookEventsPage(PageInfo info, List<BookEvent> elements) : super(info, elements);

  BookEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  BookEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_bookEventJsonDecoder, json);
}
