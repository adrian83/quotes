import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/book/model/entity.dart';

class DeleteBookCommand {
  final String authorId, bookId;

  DeleteBookCommand(this.authorId, this.bookId);
}

class NewBookCommand {
  final String authorId, title, description;

  NewBookCommand(this.authorId, this.title, this.description);

  Book toBook() => Book(
        const Uuid().v4(),
        title,
        description,
        authorId,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateBookCommand {
  final String id, authorId, title, description;

  UpdateBookCommand(this.id, this.authorId, this.title, this.description);

  Book toBook() => Book(
        id,
        title,
        description,
        authorId,
        DateTime.now(),
        DateTime.now(),
      );
}
