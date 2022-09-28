import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/book/model/entity.dart';

class FindBookQuery {
  final String authorId, bookId;

  FindBookQuery(this.authorId, this.bookId);
}

class ListBooksByAuthorQuery {
  String authorId;
  late PageRequest pageRequest;

  ListBooksByAuthorQuery(this.authorId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, $pageRequestLabel: $pageRequest]";
}

class ListEventsByBookQuery extends FindBookQuery {
  late PageRequest pageRequest;

  ListEventsByBookQuery(String authorId, String bookId, int offset, int limit)
      : super(authorId, bookId) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, $bookIdLabel: $bookId, $pageRequestLabel: $pageRequest]";
}
