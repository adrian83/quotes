import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

class Book extends Entity {
  String title, description, authorId;

  Book(String id, this.title, this.description, this.authorId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Book.create(this.title, this.description, this.authorId) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Book.update(String id, this.title, this.description, this.authorId) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Book.fromJson(Map<String, dynamic> json)
      : this(json['id'], json['title'], json['description'], json['authorId'], DateTime.parse(json['modifiedUtc']), DateTime.parse(json['createdUtc']));

  Book.fromDB(List<dynamic> row) : this(row[0].toString().trim(), row[1].toString().trim(), row[2].toString().trim(), row[3].toString().trim(), row[4], row[5]);

  Map toJson() => super.toJson()
    ..addAll({
      "title": title,
      "authorId": authorId,
      "description": description,
    });

  String toString() => "Book [id: $id, title: $title, description: $description, authorId: $authorId, modifiedUtc: $modifiedUtc, createdUtc: $createdUtc]";
}

class BookEvent extends ESDocument {
  Book book;

  BookEvent(String docId, String operation, this.book) : super(docId, operation);

  BookEvent.created(String docId, Book book) : this(docId, ESDocument.created, book);

  BookEvent.modified(String docId, Book book) : this(docId, ESDocument.modified, book);

  BookEvent.deleted(String docId, Book book) : this(docId, ESDocument.deleted, book);

  BookEvent.fromJson(Map<String, dynamic> json) : this(json['eventId'], json['operation'], Book.fromJson(json));

  Map toJson() => super.toJson()..addAll(book.toJson());

  String toString() => "BookEvent [eventId: $eventId, operation: $operation, modifiedUtc: $modifiedUtc, book: $book]";
}


class ListBooksByAuthorRequest {
    String authorId;
    late PageRequest pageRequest;

      ListBooksByAuthorRequest(this.authorId, int offset, int limit){
pageRequest = PageRequest(limit, offset);
  }
}

class ListEventsByBookRequest {
    String authorId, bookId;
    late PageRequest pageRequest;

      ListEventsByBookRequest(this.authorId, this.bookId, int offset, int limit){
pageRequest = PageRequest(limit, offset);
  }
}

