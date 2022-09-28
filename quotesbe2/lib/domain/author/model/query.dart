import 'package:quotesbe2/domain/common/model.dart';

class FindAuthorQuery {
  final String authorId;

  FindAuthorQuery(this.authorId);
  @override
  String toString() => "FindAuthorQuery [authorId: $authorId]";
}

class DeleteAuthorQuery extends FindAuthorQuery {
  DeleteAuthorQuery(String authorId) : super(authorId);

  @override
  String toString() => "DeleteAuthorQuery [authorId: $authorId]";
}

class ListAuthorsQuery {
  late PageRequest pageRequest;

  ListAuthorsQuery(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsQuery [$pageRequestLabel: $pageRequest]";
}

class ListEventsByAuthorQuery extends FindAuthorQuery {
  final PageRequest pageRequest;

  ListEventsByAuthorQuery(String authorId, this.pageRequest) : super(authorId);

  @override
  String toString() =>
      "ListEventsByAuthorQuery [authorId: $authorId, $pageRequestLabel: $pageRequest]";
}
