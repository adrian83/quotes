import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/book/model/entity.dart';

class FindBookQuery {
  final String authorId, bookId;

  FindBookQuery(this.authorId, this.bookId);
}

class ListBooksByAuthorQuery {
  String authorId;
  late PageRequest pageRequest;

  ListBooksByAuthorQuery(this.authorId, this.pageRequest);

  @override
  String toString() => "ListBooksByAuthorQuery [$bookAuthorIdLabel: $authorId, $pageRequestLabel: $pageRequest]";
}

class ListEventsByBookQuery extends FindBookQuery {
  late PageRequest pageRequest;

  ListEventsByBookQuery(super.authorId, super.bookId, this.pageRequest);

  @override
  String toString() => "ListBooksByAuthorRequest [$bookAuthorIdLabel: $authorId, $bookIdLabel: $bookId, $pageRequestLabel: $pageRequest]";
}
