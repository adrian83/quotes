import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

const bookAuthorIdLabel = 'authorId';
const bookTitleLabel = 'title';
const bookDescLabel = 'description';

class Book extends Entity with Document {
  String title, description, authorId;

  Book(String id, this.title, this.description, this.authorId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Book.create(this.title, this.description, this.authorId)
      : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Book.update(String id, this.title, this.description, this.authorId)
      : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Book.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[bookTitleLabel], json[bookDescLabel], json[bookAuthorIdLabel],
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => id;

  Map toJson() => super.toJson()
    ..addAll({
      bookTitleLabel: title,
      bookAuthorIdLabel: authorId,
      bookDescLabel: description,
    });

  String toString() =>
      "Book [$idLabel: $id, $bookTitleLabel: $title, $bookDescLabel: $description, $bookAuthorIdLabel: $authorId, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class BookEvent extends Event<Book> with Document {
  BookEvent(String id, String operation, Book book, DateTime modified, DateTime created)
      : super(id, operation, book, modified, created);

  BookEvent.create(Book book) : super(Uuid().v4(), Event.created, book, DateTime.now().toUtc(), DateTime.now().toUtc());

  BookEvent.update(Book book)
      : super(Uuid().v4(), Event.modified, book, DateTime.now().toUtc(), DateTime.now().toUtc());

  BookEvent.delete(Book book) : super(Uuid().v4(), Event.deleted, book, DateTime.now().toUtc(), DateTime.now().toUtc());

  BookEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationLabel], Book.fromJson(json[entityLabel]),
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => this.id;

  String toString() =>
      "BookEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}

class ListBooksByAuthorRequest {
  String authorId;
  late PageRequest pageRequest;

  ListBooksByAuthorRequest(this.authorId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}

class ListEventsByBookRequest {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListEventsByBookRequest(this.authorId, this.bookId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}
