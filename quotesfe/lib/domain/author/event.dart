import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/domain/page.dart';

class AuthorEvent extends Author {
  final String _eventId, _operation;

  AuthorEvent(this._eventId, this._operation, Author author) : super(author.id, author.name, author.description, author.modifiedUtc, author.createdUtc);

  AuthorEvent.fromJson(Map<String, dynamic> json) : this(json[fieldEventId], json[fieldEventOperation], Author.fromJson(json[fieldEventEntity]));

  String get eventId => _eventId;
  String get operation => _operation;

  @override
  Map toJson() => super.toJson()..addAll({fieldEventEventId: _eventId, fieldEventOperation: _operation});
}

JsonDecoder<AuthorEvent> _authorEventJsonDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);

class AuthorEventsPage extends Page<AuthorEvent> {
  AuthorEventsPage(super.info, super.elements);

  AuthorEventsPage.empty() : super(PageInfo(0, 0, 0), []);

  AuthorEventsPage.fromJson(Map<String, dynamic> json) : super.fromJson(_authorEventJsonDecoder, json);
}
