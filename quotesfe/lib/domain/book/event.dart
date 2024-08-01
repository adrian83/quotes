import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/domain/page.dart';


class BookEvent extends Book {
  final String _eventId, _operation;

  BookEvent(this._eventId, this._operation, Book book) : super(book.id, book.title, book.description, book.authorId, book.modifiedUtc, book.createdUtc);

  BookEvent.fromJson(Map<String, dynamic> json) : this(json[fieldEventId], json[fieldEventOperation], Book.fromJson(json[fieldEventEntity]));

  String get eventId => _eventId;
  String get operation => _operation;

  @override
  Map toJson() => super.toJson()..addAll({fieldEventEventId: _eventId, fieldEventOperation: _operation});
}

JsonDecoder<BookEvent> _bookEventJsonDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventsPage extends Page<BookEvent> {
  BookEventsPage(super.info, super.elements);

  BookEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  BookEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_bookEventJsonDecoder, json);
}
