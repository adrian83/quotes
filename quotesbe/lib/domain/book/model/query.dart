import 'package:quotesbe/domain/common/model.dart';
import 'package:quotes_common/domain/page.dart';

class FindBookQuery {
  final String authorId, bookId;

  FindBookQuery(this.authorId, this.bookId);
}

class ListBooksByAuthorQuery {
  String authorId;
  late PageRequest pageRequest;

  ListBooksByAuthorQuery(this.authorId, this.pageRequest);

  @override
  String toString() => "ListBooksByAuthorQuery [authorId: $authorId, $pageRequestLabel: $pageRequest]";
}

class ListEventsByBookQuery extends FindBookQuery {
  late PageRequest pageRequest;

  ListEventsByBookQuery(super.authorId, super.bookId, this.pageRequest);

  @override
  String toString() => "ListBooksByAuthorRequest [authorId: $authorId, bookId: $bookId, $pageRequestLabel: $pageRequest]";
}
