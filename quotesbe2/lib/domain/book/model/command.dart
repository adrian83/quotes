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

class UpdateBookCommand extends NewBookCommand {
  final String bookId;

  UpdateBookCommand(
    String authorId,
    this.bookId,
    String title,
    String description,
  ) : super(authorId, title, description);

  @override
  Book toBook() => Book(
        bookId,
        title,
        description,
        authorId,
        DateTime.now(),
        DateTime.now(),
      );
}
