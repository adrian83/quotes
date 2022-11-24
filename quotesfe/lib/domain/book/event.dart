import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/domain/common/page.dart';

class BookEvent extends Book {
  String eventId, operation;

  BookEvent(this.eventId, this.operation, Book book)
      : super(book.id, book.title, book.description, book.authorId,
            book.modifiedUtc, book.createdUtc);

  BookEvent.fromJson(Map<String, dynamic> json)
      : this(json[fieldEventId], json[fieldEventOperation],
            Book.fromJson(json[fieldEventEntity]));

  @override
  Map toJson() => super.toJson()
    ..addAll({fieldEventEventId: eventId, fieldEventOperation: operation});
}

JsonDecoder<BookEvent> _bookEventJsonDecoder =
    (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventsPage extends Page<BookEvent> {
  BookEventsPage(PageInfo info, List<BookEvent> elements)
      : super(info, elements);

  BookEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  BookEventsPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookEventJsonDecoder, json);
}
