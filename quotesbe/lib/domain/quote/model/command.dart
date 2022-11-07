import 'package:uuid/uuid.dart';

import 'package:quotesbe/domain/quote/model/entity.dart';

class DeleteQuoteCommand {
  final String authorId, bookId, quoteId;

  DeleteQuoteCommand(this.authorId, this.bookId, this.quoteId);
}

class NewQuoteCommand {
  final String authorId, bookId, text;

  NewQuoteCommand(this.authorId, this.bookId, this.text);

  Quote toQuote() => Quote(
        const Uuid().v4(),
        text,
        authorId,
        bookId,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateQuoteCommand extends NewQuoteCommand {
  final String quoteId;

  UpdateQuoteCommand(String authorId, String bookId, this.quoteId, String text)
      : super(authorId, bookId, text);

  @override
  Quote toQuote() => Quote(
        quoteId,
        text,
        authorId,
        bookId,
        DateTime.now(),
        DateTime.now(),
      );
}
