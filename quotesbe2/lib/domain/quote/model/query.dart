import 'package:quotesbe2/domain/common/model.dart';

class FindQuoteQuery {
  final String authorId, bookId, quoteId;

  FindQuoteQuery(this.authorId, this.bookId, this.quoteId);
}

class ListQuotesFromBookQuery {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListQuotesFromBookQuery(this.authorId, this.bookId, this.pageRequest);

  @override
  String toString() =>
      "ListQuotesFromBookQuery [authorId: $authorId, bookId: $bookId, pageRequest: $pageRequest]";
}


class ListEventsByQuoteQuery {
  String authorId, bookId, quoteId;
  late PageRequest pageRequest;

  ListEventsByQuoteQuery(
    this.authorId,
    this.bookId,
    this.quoteId,
    int offset,
    int limit,
  ) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListEventsByQuoteQuery [authorId: $authorId, bookId: $bookId, quoteId: $quoteId, pageRequest: $pageRequest]";
}