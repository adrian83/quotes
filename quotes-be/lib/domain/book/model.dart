import 'package:uuid/uuid.dart';

import '../common/model.dart';
import '../../infrastructure/elasticsearch/document.dart';

const bookAuthorIdLabel = 'authorId';
const bookTitleLabel = 'title';
const bookDescLabel = 'description';
const bookIdLabel = 'bookId';

class Book extends Entity with Document {
  String title, description, authorId;

  Book(String id, this.title, this.description, this.authorId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Book.create(this.title, this.description, this.authorId) : super.create();

  Book.update(String id, this.title, this.description, this.authorId) : super(id, nowUtc(), nowUtc());

  Book.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[bookTitleLabel], json[bookDescLabel], json[bookAuthorIdLabel],
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  @override
  String getId() => id;

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(createdUtcLabel);

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()
    ..addAll({
      bookTitleLabel: title,
      bookAuthorIdLabel: authorId,
      bookDescLabel: description,
    });

  @override
  String toString() =>
      "Book [$idLabel: $id, $bookTitleLabel: $title, $bookDescLabel: $description, $bookAuthorIdLabel: $authorId, " +
      "$modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class BookEvent extends Event<Book> with Document {
  BookEvent(String id, String operation, Book book, DateTime modified, DateTime created)
      : super(id, operation, book, modified, created);

  BookEvent.create(Book book) : super(Uuid().v4(), Event.created, book, nowUtc(), nowUtc());

  BookEvent.update(Book book) : super(Uuid().v4(), Event.modified, book, nowUtc(), nowUtc());

  BookEvent.delete(Book book) : super(Uuid().v4(), Event.deleted, book, nowUtc(), nowUtc());

  BookEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationLabel], Book.fromJson(json[entityLabel]),
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  @override
  String getId() => this.id;

  @override
  String toString() =>
      "BookEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, " +
      "$createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}

class ListBooksByAuthorRequest {
  String authorId;
  late PageRequest pageRequest;

  ListBooksByAuthorRequest(this.authorId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, pageRequest: $pageRequest]";
}

class ListEventsByBookRequest {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListEventsByBookRequest(this.authorId, this.bookId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, $bookIdLabel: $bookId, " + "pageRequest: $pageRequest]";
}
