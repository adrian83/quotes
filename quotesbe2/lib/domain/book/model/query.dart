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
      "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, pageRequest: $pageRequest]";
}

class ListEventsByBookQuery {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListEventsByBookQuery(this.authorId, this.bookId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, $bookIdLabel: $bookId, pageRequest: $pageRequest]";
}

